ARCHS = arm64
TARGET = iphone:clang:16.0:14.0
PACKAGE_VERSION = 0.2.2
include $(THEOS)/makefiles/common.mk
TWEAK_NAME = MacSpoof
MacSpoof_FILES = Tweak.xm
MacSpoof_FRAMEWORKS = Foundation UIKit
MacSpoof_PRIVATE_FRAMEWORKS = WiFiKit MobileWiFi
MacSpoof_CFLAGS = -fobjc-arc
include $(THEOS_MAKE_PATH)/tweak.mk
