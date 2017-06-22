moment = require('moment');
moment.locale('ko')

weatherURL = 'http://api.openweathermap.org/data/2.5/weather?q=daejeon&appid=8b693a3e5f2d1e9bbfc8908514e9d2bd&lang=kr&units=metric'
dailyURL = 'http://api.openweathermap.org/data/2.5/forecast/daily?q=daejeon&appid=8b693a3e5f2d1e9bbfc8908514e9d2bd&lang=kr&units=metric';

module.exports = (robot) ->
  robot.hear /날씨/i, (msg) ->
    weatherFor(msg)

  robot.hear /나알씨이/i, (msg) ->
    getDailyWeather(msg)

  weatherFor = (msg) ->
    robot.http(weatherURL).get() (err, res, body) ->
      json = JSON.parse body

      weather = json.weather[0].description + "(" + json.weather[0].main + ")";

      msg.send "현재 대전 날씨는 #{weather}입니다. 기온는 #{Math.round(json.main.temp)}°C 입니다."


  getDailyWeather = (msg) ->
    robot.http(dailyURL).get() (err, res, body) ->
      json = JSON.parse body

      message = '';

      message += json.list.length + ' 일 동안의 대전 날씨!\n\n';

      json.list.forEach (daily) ->
        weather = daily.weather[0].description + '(' + daily.weather[0].main + ')';

        message += moment.unix(daily.dt).format('MM월 DD일 (ddd)') + '\n';
        message += '날씨 : ' + weather + '\n';
        message += '최저 : ' + Math.round(daily.temp.min) + '°C, 최고 : ' + Math.round(daily.temp.max) + '°C\n\n';

      message = message.trim();

      msg.send message