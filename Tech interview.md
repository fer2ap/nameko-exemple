What's happening: The longer we run tests, the worse the performance gets.

Problem 1: The Products Service has a problem with the list method. When it's called, it will return all the entries on the Redis Database. This may cause severous problems in the future, when the amount of data on Redis grows larger.

Problem 2: Every order returned by the gateway is enhanced with its respective product for each order_detail. The original get_order on the gateway service used the products.list() to perform this enhancement, which is not optimal because you don't need all the database entries to perform this operation. 

Hipotesis: Every iteration of the Performance Test is creating new entries on the Products Redis database. The default implementation is performing a query for each order queried that returns all the entries on the Redis database. This huge amout of data must be transfered beteween services, causing an increment in response time and sometimes errors.

Validation: First we must perform a long test on the orginal implementation of the code base. After getting enough data about its deteriorating performance we can refactor the Gateway service to use the get product by id and run the performance tests again. Compare both results. This validation may be done on the master branch, where there is no code done by me, in order to remove this incertainty. 