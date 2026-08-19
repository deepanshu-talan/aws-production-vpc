#!/bin/bash
set -euxo pipefail

# ---------------------------------------------------------------------------
# System Updates
# ---------------------------------------------------------------------------
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get upgrade -y

# ---------------------------------------------------------------------------
# Python & Flask Application
# ---------------------------------------------------------------------------
apt-get install -y python3 python3-pip python3-venv

mkdir -p /opt/app
cd /opt/app

python3 -m venv venv
source venv/bin/activate
pip install flask

cat > app.py << 'FLASK_APP'
from flask import Flask
import socket

app = Flask(__name__)

@app.route("/")
def home():
    hostname = socket.gethostname()
    return f"""
    <!DOCTYPE html>
    <html>
    <head><title>AWS VPC Demo</title></head>
    <body>
        <h1>AWS VPC Infrastructure</h1>
        <p>Instance: <strong>{hostname}</strong></p>
        <p>Deployed in a private subnet, served through the Application Load Balancer.</p>
    </body>
    </html>
    """

@app.route("/health")
def health():
    return "OK", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
FLASK_APP

# ---------------------------------------------------------------------------
# Run Flask as a systemd service
# ---------------------------------------------------------------------------
cat > /etc/systemd/system/flask-app.service << SERVICE
[Unit]
Description=Flask Application
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/app
ExecStart=/opt/app/venv/bin/python app.py
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
SERVICE

systemctl daemon-reload
systemctl enable flask-app
systemctl start flask-app

# ---------------------------------------------------------------------------
# CloudWatch Agent
# ---------------------------------------------------------------------------
apt-get install -y wget

wget -q https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
dpkg -i amazon-cloudwatch-agent.deb
rm -f amazon-cloudwatch-agent.deb

mkdir -p /opt/aws/amazon-cloudwatch-agent/etc

cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << 'CW_CONFIG'
{
  "metrics": {
    "namespace": "CustomMetrics",
    "metrics_collected": {
      "mem": {
        "measurement": ["mem_used_percent"],
        "metrics_collection_interval": 60
      },
      "disk": {
        "measurement": ["disk_used_percent"],
        "metrics_collection_interval": 60,
        "resources": ["*"]
      }
    },
    "append_dimensions": {
      "InstanceId": "${aws:InstanceId}",
      "AutoScalingGroupName": "${aws:AutoScalingGroupName}"
    }
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/syslog",
            "log_group_name": "/aws/ec2/syslog",
            "log_stream_name": "{instance_id}"
          },
          {
            "file_path": "/var/log/flask-app.log",
            "log_group_name": "/aws/ec2/flask-app",
            "log_stream_name": "{instance_id}"
          }
        ]
      }
    }
  }
}
CW_CONFIG

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
  -s

echo "User data script completed successfully"
