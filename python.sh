#!/bin/bash

# =========================
# Update
# =========================
sudo apt update

# =========================
# Python and a few Python libs
# =========================

sudo apt install -y python3-full python3-dev python3-setuptools python3-pil python3-typing-extensions
sudo apt install -y python3-opencv python3-boto3 python3-pyocr python3-gv python3-tabulate
sudo apt install -y python3-all-dev python3-opencv-apps python3-boto python-is-python3 black
sudo apt install -y python3-jinja2 python3-shellingham tesseract-ocr python3-pyperclip python3-six
sudo apt install -y python3-colorama python3-yaml libreadline-dev libreadline8 readline-common
sudo apt install -y python3-click python3-click-completion python3-rich python3-aalib python3-mako
sudo apt install -y python3-scapy python3-chardet python3-html2text python3-pytools python3-qrcode
sudo apt install -y python3-unidecode ruby-asciidoctor python3-sh python3-zstd uxplay gir1.2-vte-2.91
sudo apt install -y python3-requests python3-requests-file python3-ipython ipython3 gir1.2-keybinder-3.0
sudo apt install -y python3-cryptography python3-matplotlib python3-pyx python3-cairocffi
sudo apt install -y python3-cairosvg python3-gi python3-gi-cairo python3-scipy python3-sip
sudo apt install -y python3-tornado python3-twisted python3-pampy python3-pycurl python3-serial
sudo apt install -y python3-wxgtk4.0 python3-parallel python3-psutil python3-configobj python3-sphinx
sudo apt install -y python3-distutils python3-tk python3-wxgtk-media4.0 python3-wxgtk-webview4.0

# =========================
# Update
# =========================
sudo apt  update
echo "Done —  installed complete."
