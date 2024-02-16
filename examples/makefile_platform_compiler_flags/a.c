void f() {
#ifndef FLAG_ENABLED
  error!
#endif

#ifndef X86_64_FLAG_ENABLED
  error!
#endif

#ifdef IOS_FLAG_DISABLED
  error!
#endif

#ifdef ARM_FLAG_DISABLED
  error!
#endif
}