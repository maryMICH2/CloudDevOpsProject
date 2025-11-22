resource "aws_security_group" "app" {
  name        = "${var.name}-app-sg"
  description = "Security group for application instances"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = [22, 80, 443, 8080, 5000]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.name}-sg"
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "jenkins_master" {
  tags = {
    Name = "jenkins-master"
    Role = "Jenkins-Master"
  }
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = var.public_subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.app.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }
}

resource "aws_instance" "jenkins_worker" {
  tags = {
    Name = "jenkins-worker"
    Role = "Jenkins-Worker"
  }
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = var.public_subnet_ids[1]
  vpc_security_group_ids      = [aws_security_group.app.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }
}

# ---------------------------------------
# SNS Topic for Notifications
# ---------------------------------------
resource "aws_sns_topic" "alerts_topic" {
  name = "${var.name}-alerts-topic"
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.alerts_topic.arn
  protocol  = "email"
  endpoint  = var.alert_email
}


resource "aws_cloudwatch_metric_alarm" "jenkins_master_cpu" {
  alarm_name          = "${var.name}-jenkins-master-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "High CPU usage detected"

  alarm_actions = [aws_sns_topic.alerts_topic.arn]

  dimensions = {
    InstanceId = aws_instance.jenkins_master.id
  }
}

resource "aws_cloudwatch_metric_alarm" "jenkins_worker_cpu" {
  alarm_name          = "${var.name}-jenkins-worker-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "High CPU usage detected"

  alarm_actions = [aws_sns_topic.alerts_topic.arn]

  dimensions = {
    InstanceId = aws_instance.jenkins_worker.id
  }
}
