//getopt.hÎÄ¼þ´úÂë£º
#ifndef _GETOPT_
#define _GETOPT_
//static int getopt(int argc, char **argv, char *ostr);
extern char *optarg;  // returned arg to go with this option
extern int optind;  // index to next argv element to process
extern int opterr;  // should error messages be printed?
extern int optopt;  //
#define BADCH ('?')
#endif // _GETOPT

