# fastweather

Quick and dirty coding test for interview.

If a real production app:
* Don't use flask webserver
* Hide API key
* Use python module.

## Usage

GET /getweather/<zipcode> where zipcode is a 5 digit or 9 digit U.S. zipcode.

Returns JSON formatted as:

```
{"coord":{"lon":-0.13,"lat":51.51},"weather":[{"id":300,"main":"Drizzle","description":"light intensity drizzle","icon":"09d"}],"base":"stations","main":{"temp":280.32,"pressure":1012,"humidity":81,"temp_min":279.15,"temp_max":281.15},"visibility":10000,"wind":{"speed":4.1,"deg":80},"clouds":{"all":90},"dt":1485789600,"sys":{"type":1,"id":5091,"message":0.0103,"country":"GB","sunrise":1485762037,"sunset":1485794875},"id":2643743,"name":"London","cod":200}
```
## Infrastructure deploy

docker build the project and push to a publicly available registry.

Specify container in the aws_ecs_service dask definition (To-Do) in ./deploy
