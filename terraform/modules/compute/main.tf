data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"

    values = [
      "al2023-ami-2023.*-x86_64"
    ]
  }

  filter {
    name = "architecture"

    values = [
      "x86_64"
    ]
  }

  filter {
    name = "virtualization-type"

    values = [
      "hvm"
    ]
  }
}

resource "aws_iam_role" "ec2_ssm" {
  name = "${var.project_name}-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-ec2-ssm-role"
  }
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.ec2_ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm" {
  name = "${var.project_name}-ec2-ssm-profile"
  role = aws_iam_role.ec2_ssm.name
}

resource "aws_instance" "app" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type

  subnet_id = var.private_app_subnet_ids[0]

  vpc_security_group_ids = [
    var.ec2_sg_id
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2_ssm.name

  user_data = <<-EOF
    #!/bin/bash
    dnf update -y

    cat <<'APP' > /opt/app.py
    from http.server import BaseHTTPRequestHandler, HTTPServer
    import json

    class Handler(BaseHTTPRequestHandler):
        def do_GET(self):
            if self.path == "/api/health":
                body = {"status": "ok"}
                self.send_response(200)
                self.send_header("Content-Type", "application/json")
                self.end_headers()
                self.wfile.write(json.dumps(body).encode())

            elif self.path == "/api/message":
                body = {"message": "Hello from EC2 API"}
                self.send_response(200)
                self.send_header("Content-Type", "application/json")
                self.end_headers()
                self.wfile.write(json.dumps(body).encode())

            else:
                body = {"error": "not found"}
                self.send_response(404)
                self.send_header("Content-Type", "application/json")
                self.end_headers()
                self.wfile.write(json.dumps(body).encode())

    server = HTTPServer(("0.0.0.0", 80), Handler)
    server.serve_forever()
    APP

    cat <<'SERVICE' > /etc/systemd/system/app.service
    [Unit]
    Description=Simple API Server
    After=network.target

    [Service]
    ExecStart=/usr/bin/python3 /opt/app.py
    Restart=always

    [Install]
    WantedBy=multi-user.target
    SERVICE

    systemctl daemon-reload
    systemctl enable app.service
    systemctl start app.service
  EOF

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "${var.project_name}-app-ec2"
  }
}
