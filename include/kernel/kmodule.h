#ifndef KMODULE_H
#define KMODULE_H

#ifdef __GFORTRAN__

#define MODULE_INIT(fun) \
	procedure(), pointer :: module_init => fun



#endif

#endif
