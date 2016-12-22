# _Bright Sky_

#### _Weather Application, 1.0.0, 12/22/16_

#### By _Michael Andrade, Skye Atwood, Jacob Hixon, and Eric Bomblatus, with thanks to Epicodus_

## Description

A weather application allowing you to search for locations (or add and save them) and view the current forecast, as well as the 3-day outlook for that location.

## Setup/Installation Requirements

1. _Clone into repository located at https://github.com/andrademichael/bright_sky ._
2. _In the terminal, make sure you are inside of the project folder, then type the following commands:_
  * _$ bundle install_
  * _$ rake db:create_
  * _$ rake db:migrate_ _(Note: if this command returns an error, run '$ bundle exec rake db:migrate' instead_
  * _$ ruby app.rb_
3. _create a file named '.env' in the top level of your project folder and put your API keys into the file in the following format:_
  * _GOOGLE_GEOCODE_KEY=yourgooglekey_
  * _DARK_SKY_KEY=yourdarkskykey_
4. _visit 'localhost:4567'_

_Alternatively, visit https://sheltered-earth-72289.herokuapp.com/ to try our demo_
## Known Bugs

* _Works best with cities in the USA, Canada, and the UK; may encounter errors with location accuracy otherwise_

## Support and contact details

_For questions, ideas, or concerns, tweet our colleagues at @Twittamir_Putin_
_Alternatively, email me with the subject 'Bright Sky Github'_

## Technologies Used

* _Ruby_
* _Sinatra_
* _ActiveRecord_
* _PostgreSQL_
* _Heroku_
* _Google Geocoding API_
* _Dark Sky API_

### License

This file is part of (Bright Sky).

    (Bright Sky) is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    (Bright Sky) is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with the (Bright Sky). If not, see <http://www.gnu.org/licenses/>.

Copyright (c) 2016 **_Michael Andrade, Jacob Hixon, Skye Atwood, Eric Bomblatus_**
