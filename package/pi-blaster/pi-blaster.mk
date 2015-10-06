################################################################################
# 
# pi-blaster
#
################################################################################

PI_BLASTER_VERSION = ec5e1b4c6191d8f9a538497dbbb86f9cf0de7016
PI_BLASTER_SITE = $(call github,sarfata,pi-blaster,$(PI_BLASTER_VERSION))
PI_BLASTER_DEPENDENCIES = host-autoconf host-automake


# The standard <pkg>_AUTORECONF = YES invocation doesn't work for this
# # package, because it does not use automake in a normal way.
define PI_BLASTER_RUN_AUTOGEN
	cd $(@D) && PATH=$(BR_PATH) ./autogen.sh
endef
PI_BLASTER_PRE_CONFIGURE_HOOKS += PI_BLASTER_RUN_AUTOGEN

$(eval $(autotools-package))
