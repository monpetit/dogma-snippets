#ifndef MUS_CONFIG_H_
#define MUS_CONFIG_H_

#ifndef USE_READLINE_LIBRARY
#define USE_READLINE_LIBRARY    1
#endif

#ifndef INIT_LOCALE
#define INIT_LOCALE    std::locale::global(std::locale(""))
#endif

#endif // MUS_CONFIG_H_
