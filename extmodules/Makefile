obj-m += hello.o

KDIR := ~/nagarajlinuxmod1/linux-6.18.1
PWD  := $(shell pwd)

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean

