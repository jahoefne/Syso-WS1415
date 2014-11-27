LED5_VERSION = 1.0
LED5_SITE_METHOD = local
LED5_SITE = /home/jahoefne/syso/V3/package/led5.c

define LED5_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" LD="$(TAGET_LD)" -C $(@D)
endef

define LED5_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/* $(TARGET_DIR)/bin
endef

$(eval $(generic-package))
