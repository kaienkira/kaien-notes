#!/bin/bash

XMODIFIERS="@im=fcitx5" \
GTK_IM_MODULE=fcitx5 \
QT_IM_MODULE=fcitx5 \
GLFW_IM_MODULE=ibus \
exec sway
