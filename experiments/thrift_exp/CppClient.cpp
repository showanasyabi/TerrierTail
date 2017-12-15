/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements. See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership. The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

#include <iostream>
#include <cmath>
#include <stdio.h>
#include <signal.h>

#include <thrift/protocol/TBinaryProtocol.h>
#include <thrift/transport/TSocket.h>
#include <thrift/transport/TTransportUtils.h>
#include <stdlib.h>
#include "../gen-cpp/Calculator.h"

using namespace std;
using namespace apache::thrift;
using namespace apache::thrift::protocol;
using namespace apache::thrift::transport;

using namespace tutorial;
using namespace shared;

#define size 3000000
int times[size];
int index_shit = 0;

float nextTime(float rateParameter)
{
    return -logf(1.0f - (float) random() / (RAND_MAX)) / rateParameter;
}

void myhandler(int s)
{
	for(int i = 0; i < index_shit; ++i)
	{
		cout << times[i] << endl;
	}
	//cerr << "exit" << endl;	
	exit(0);
}

int main(int argc, char *argv[]) {
  //boost::shared_ptr<TTransport> socket(new TSocket("172.16.1.62", 9090));
  boost::shared_ptr<TTransport> socket(new TSocket( argv[2], 9090));
  boost::shared_ptr<TTransport> transport(new TBufferedTransport(socket));
  boost::shared_ptr<TProtocol> protocol(new TBinaryProtocol(transport));
  CalculatorClient client(protocol);
  int interval = atoi(argv[1]);
  signal(SIGINT, myhandler);
  //cout <<interval<<endl;
  try {
    transport->open();

    //client.ping();
	struct timeval tp;
	struct timeval tp_new;
	long int ms;
	int answer;
	//cout << "ping()" << endl;
	while(index_shit < size)
	{ 
		gettimeofday(&tp, NULL);
		answer = client.add(500, 600);
		gettimeofday(&tp_new, NULL);
		ms = 1000000 * (tp_new.tv_sec - tp.tv_sec) + (tp_new.tv_usec - tp.tv_usec);
		times[index_shit++] = ms;
		double a= nextTime(interval) * 1000000;
		usleep(a);
	}
		cout << "done" << endl;


	/*
    cout << "1 + 1 = " << client.add(1, 1) << endl;

    Work work;
    work.op = Operation::DIVIDE;
    work.num1 = 1;
    work.num2 = 0;

    try {
      client.calculate(1, work);
      cout << "Whoa? We can divide by zero!" << endl;
    } catch (InvalidOperation& io) {
      cout << "InvalidOperation: " << io.why << endl;
      // or using generated operator<<: cout << io << endl;
      // or by using std::exception native method what(): cout << io.what() << endl;
    }

    work.op = Operation::SUBTRACT;
    work.num1 = 15;
    work.num2 = 10;
    int32_t diff = client.calculate(1, work);
    cout << "15 - 10 = " << diff << endl;

    // Note that C++ uses return by reference for complex types to avoid
    // costly copy construction
    SharedStruct ss;
    client.getStruct(ss, 1);
    cout << "Received log: " << ss << endl;
	*/
    transport->close();
  } catch (TException& tx) {
    cout << "ERROR: " << tx.what() << endl;
  }
}

