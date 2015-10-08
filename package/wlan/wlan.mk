################################################################################
#
# wlan
#
################################################################################

# source included in buildroot
WLAN_SOURCE =

define WLAN_INSTALL_TARGET_CMDS
	echo $(BR2_PACKAGE_WLAN_IP) > $(TARGET_DIR)/etc/foo
endef

$(eval $(generic-package))
