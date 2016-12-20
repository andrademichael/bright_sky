$(document).ready(function(){
  $('.parallax').parallax();
  $('#search_form').submit(function(event) {
    if ($('#zip_input').val() === '') {
      if ($('#city_input').val() === '' && $('#state_input').val() === '') {
        alert('Please enter a city and state or zipcode')
        event.preventDefault()
      }
      else if ($('#city_input').val() === '' && $('#state_input').val() !== '') {
        alert('Please enter a city')
        event.preventDefault()
      }
      else if ($('#city_input').val() !== '' && $('#state_input').val() === '') {
        alert('Please enter a state')
        event.preventDefault()
      }
    }
    else if ($('#city_input').val() === '' && $('#state_input').val() === '') {
      if ($('#zip_input').val() === '') {
        alert('Please enter a city and state or zipcode')
        event.preventDefault()
      }
      else if ($('#zip_input').val().length() < 4) {
        alert('Please enter a 4- or 5-character zipcode')
        event.preventDefault()
      }
    }
  });
});
