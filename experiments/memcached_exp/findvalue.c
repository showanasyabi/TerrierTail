#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <libmemcached/memcached.h>
#include <time.h>
#include <assert.h>
#include <stdlib.h>
#include <math.h>
#include <signal.h>


static int allow_to_request = 1;


float nextTime(float rateParameter)
{
    float temp = -logf(1.0f - (float) random() / (RAND_MAX)) / rateParameter;
    return temp;
}

void sigintHandler(int signal)
{
    printf("CTRL pressed experiments ended\n");
    allow_to_request = 0;
}

void rand_str(char *dest, size_t length) {
    char charset[] = "0123456789"
                     "abcdefghijklmnopqrstuvwxyz"
                     "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

    while (length-- > 0) {
        size_t index = (double) rand() / RAND_MAX * (sizeof charset - 1);
        *dest++ = charset[index];
    }
    *dest = '\0';
}

int main(int argc, char *argv[])
{
  memcached_server_st *servers = NULL;
  memcached_st *memc;
  memcached_return rc;
  int i=0;
  unsigned long testnumber=0;
  int now;
  int rate_limit;

  rate_limit = atoi(argv[1]);

  struct timeval time_before, time_next;

  char *key= "LOOOOOOOOOOOOOOONNNNNGGGGGGGGKKKKKKEEEEEEEEEEEEEEYYYYYYY";
  char *value= "LOOOOOOOOOOOOOOONNNNNGGGGGGGGVVVVVVVVVAAAAAAAAAAAAALLLLLLLLLLLLUUUUUUUUEEEEEEEE";
  uint32_t flags;
  size_t return_value_length;

  char * ip = argv[2];

  //Register Signal Handler
  signal(SIGINT, sigintHandler);

  memc= memcached_create(NULL);
  servers= memcached_server_list_append(servers, ip, 11211, &rc);
  rc= memcached_server_push(memc, servers);

  rc= memcached_set(memc, key, strlen(key), value, strlen(value), (time_t)0, (uint32_t)0);

  char * res;

  while ( true)
  {

    now = nextTime(rate_limit) * 1000000;
    usleep(now);

    gettimeofday (&time_before, NULL);
    res = memcached_get(memc, key, strlen(key), &return_value_length, &flags, &rc);
    gettimeofday(&time_next, NULL);
    free(res);
    if(rc != MEMCACHED_SUCCESS)
    {
      fprintf(stderr, "No result experiment ended\n");
    }

    if(allow_to_request == 0)
    {
	break;
    }


    int diff;
    diff = (time_next.tv_sec - time_before.tv_sec)*1000000 + (time_next.tv_usec - time_before.tv_usec);
    fprintf(stderr, "%d\n", diff);
  }

  memcached_free(memc);

  return 0;
}
