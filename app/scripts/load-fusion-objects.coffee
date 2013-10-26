logon = {ws_host: 'https://fap0912-crm.oracleads.com', user : 'lisa.jones', pwd : 'rYW34347'}
crm_server = 'http://fusion-crm-server.herokuapp.com/'

two_line = /\n\n/g
one_line = /\n/g
linebreak = (s) ->
  s.replace(two_line, '<p></p>').replace(one_line, '<br>')

first_char = /\S/;
capitalize = (s) ->
  s.replace(first_char, (m) -> m.toUpperCase())

final_transcript = ''

load_oppties =  ->
  $('#data-table').replaceWith($('<span id="loading">Loading your data ...</span>'))
  $('#overlay').show();
  $.ajax({
    url: crm_server + "/opportunities?ws_host=" + logon.ws_host + "&user=" + logon.user + "&pwd=" + logon.pwd,
    type: "GET",
    crossDomain: true,
    dataType: "JSON",
    success: (data) ->
      $table = $('<table id="data-table" class="table table-hover">')
      $table.append('<thead>').children('thead')
        .append('<tr />').children('tr')
        .append('<th>Name</th><th>Description</th>')

      $tbody = $table.append('<tbody />').children('tbody')

      $.each(data, (index,oppty) ->
        $tbody.append('<tr />').children('tr:last')
          .append("<td class='major'>" + oppty.name + "</td>")
          .append("<td>" + oppty.description_text + "</td>")
      )
      $('#loading').replaceWith($table)
      $('#overlay').hide();
      console.log("success")
    ,
    error: (data) ->
      console.log(data)
      console.log("error")
      $('#loading').replaceWith($('<span id="loading">Could not load your data</span>'))
      $('#overlay').hide();
  })

load_leads =  ->
  $('#data-table').replaceWith($('<span id="loading">Loading your data ...</span>'))
  $('#overlay').show();
  $.ajax({
    url: crm_server + "/sales_leads?ws_host=" + logon.ws_host + "&user=" + logon.user + "&pwd=" + logon.pwd,
    type: "GET",
    crossDomain: true,
    dataType: "JSON",
    success: (data) ->
      $table = $('<table id="data-table" class="table table-hover">')
      $table.append('<thead>').children('thead')
        .append('<tr />').children('tr')
        .append('<th>Rank</th><th>Name</th><th>Customer</th><th>Deal Size</th><th>Primary Contact</th>')

      $tbody = $table.append('<tbody />').children('tbody')

      $.each(data, (index, lead) ->
        if lead.rank == 'HOT'
          rankIcon = "<img src='images/fuse-icon-rank-hot.png' alt='#{lead.rank}' title='#{lead.rank}'>"
        else if lead.rank == 'WARM'
          rankIcon = "<img src='images/fuse-icon-rank-warm.png' alt='#{lead.rank}' title='#{lead.rank}'>"
        else
          rankIcon = "<img src='images/fuse-icon-rank-cold.png' alt='#{lead.rank}' title='#{lead.rank}'>"
        if lead.name.length > 40
          lead_name = "#{lead.name.substr(0,39)}..."
        else
          lead_name = lead.name
        $tbody.append('<tr />').children('tr:last')
          .append("<td class='major'>" + rankIcon + "</td>")
          .append("<td>" + lead_name + "</td>")
          .append("<td>" + lead.customer_party_name + "</td>")
          .append("<td>" + accounting.formatMoney(lead.deal_amount) + "</td>")
          .append("<td>" + lead.primary_contact_party_name + "</td>")
      )
      $('#loading').replaceWith($table)
      $('#overlay').hide();
      console.log("success")
    ,
    error: (data) ->
      console.log(data)
      console.log("error")
      $('#loading').replaceWith($('<span id="loading">Could not load your data</span>'))
      $('#overlay').hide();
  })

# var load_interactions = function(){
#   $('#data-table').replaceWith($('<span id="loading">Loading your data ...</span>'));
#   $.ajax({
#     // url: "http://ec2-54-243-250-67.compute-1.amazonaws.com/api/v0.1/logon",
#     url: crm_server + "/api/v0.1/interactions?ws_host=" + logon.ws_host + "&user=" + logon.user + "&pwd=" + logon.pwd,
#     type: "GET",
#     dataType: "JSON",
#     success: function(data){
#       var $table = $('<table id="data-table" class="table table-hover">');
#       $table.append('<thead>').children('thead')
#         .append('<tr />').children('tr')
#         .append('<th>Description</th><th>Type</th><th>Direction</th>');

#       var $tbody = $table.append('<tbody />').children('tbody');

#       $.each(data, function(index,interaction){
#         $tbody.append('<tr />').children('tr:last')
#           .append("<td>" + interaction.interaction_description + "</td>")
#           .append("<td>" + interaction.interaction_type_code + "</td>")
#           .append("<td>" + interaction.direction_code + "</td>");
#       });
#       $('#loading').replaceWith($table);
#       console.log("success");
#     },
#     error: function(data){
#       console.log(data);
#       console.log("error");
#       $('#loading').replaceWith($('<span id="loading">Could not load your data</span>'));
#     }
#   });
# };

# var load_sales_parties = function(){
#   $('#data-table').replaceWith($('<span id="loading">Loading your data ...</span>'));
#   $.ajax({
#     // url: "http://ec2-54-243-250-67.compute-1.amazonaws.com/api/v0.1/logon",
#     url: crm_server + "/api/v0.1/sales_parties?ws_host=" + logon.ws_host + "&user=" + logon.user + "&pwd=" + logon.pwd,
#     type: "GET",
#     dataType: "JSON",
#     success: function(data){
#       var $table = $('<table id="data-table" class="table table-hover">');
#       $table.append('<thead>').children('thead')
#         .append('<tr />').children('tr')
#         .append('<th>Name</th><th>Type</th>');

#       var $tbody = $table.append('<tbody />').children('tbody');

#       $.each(data, function(index,party){
#         $tbody.append('<tr />').children('tr:last')
#           .append("<td class='major'>" + party.party_name + "</td>")
#           .append("<td>" + party.party_type + "</td>");
#       });
#       $('#loading').replaceWith($table);
#       console.log("success");
#     },
#     error: function(data){
#       console.log(data);
#       console.log("error");
#       $('#loading').replaceWith($('<span id="loading">Could not load your data</span>'));
#     }
#   });
# };


$("#leads-link").on('click', ->
  console.log('click')
  load_leads()
)
$("#opportunities-link").on('click', ->
  console.log('click')
  load_oppties()
)

$(".pegasus-link").on('click', ->
  console.log "click"
  $("#pegasus-modal").modal('show')
)
# $("#interactions-link").on('click', function(){
#   console.log('click');
#   load_interactions();
# });

# $("#sales-parties-link").on('click', function(){
#   console.log('click');
#   load_sales_parties();
# });


# init page
load_leads()

$('.pegasus-input.long-pegasus-input').on('keyup', ->
  heroku_url = "http://fusion-crm-server.herokuapp.com"
  url = "http://localhost:5678/search?types[]=sales_leads&types[]=opportunities&types[]=sales_parties&types[]=tasks&term=#{$(this).val()}"
  # JSONP Call!
  $.getJSON(url + "&callback=?", null, (data) ->
    # console.log  data
    results = '<ul class="pegasus-result-sets list-unstyled">'
    # loop over all different types returned
    $.each(data.results, (key, value) ->
      if value.length != 0
        results += "<li class='#{key} result-type'>#{key}</li>"
        # loop over all different hit-results returned
        results += "<ul class='pegasus-result-set pegasus-result-set-#{key} list-unstyled'>"
        $.each(value,  (index, val) ->
          results += "<li class='result'><a href='#{heroku_url}#{val.data.url}' target='_blank'>#{val.data.subtitle} <span class='light'>(score = #{val.score})</span></a></li>"
        )
        results += "</ul>"
      )
    results += "</ul>"
    $(".pegasus-search-results").html(results)
  )
)


if window.webkitSpeechRecognition
  recognition = new webkitSpeechRecognition()
  recognition.continuous = false # = speech recognition will end when the user stops talking, otherwise it keeps on recording until it is stopped manually
  recognition.interimResults = true # = results returned by the recognizer on-the-fly

  recognition.onstart = ->
    recognizing = true
    console.log "starting voice recognition"

#   recognition.onerror = (event) ->
#     if event.error == 'no-speech'
#       ignore_onend = true
#       console.log 'no-speech'
#     if event.error == 'audio-capture'
#       ignore_onend = true
#       console.log 'no-microphone'
#     if event.error == 'not-allowed'
#       if event.timeStamp - start_timestamp < 100
#         console.log 'info_blocked'
#       else
#         console.log 'info_denied'
#       ignore_onend = true

  recognition.onend = ->
    recognizing = false
    console.log "Ended voice recognition"
#     if ignore_onend
#       return
#     if !final_transcript
#       return
#     if window.getSelection
#       window.getSelection().removeAllRanges()
#       range = document.createRange()
#       range.selectNode(document.getElementById('final_span'))
#       window.getSelection().addRange(range)

  recognition.onresult = (event) ->
    interim_transcript = ''
    for result in event.results
      if result.isFinal
        final_transcript += result[0].transcript
        $('.pegasus-input.long-pegasus-input').val(final_transcript)
        $('.pegasus-input.long-pegasus-input').trigger('keyup')
      else
        interim_transcript += result[0].transcript;
        $('.pegasus-input.long-pegasus-input').val(interim_transcript)
        $('.pegasus-input.long-pegasus-input').trigger('keyup')

    # final_transcript = capitalize(final_transcript)
    $("#final_span").html final_transcript
    $("#interim_span").html interim_transcript
    # if final_transcript || interim_transcript
    #   showButtons('inline-block')

#   startButton = (event) ->
#     if recognizing
#       recognition.stop()
#       return

#     final_transcript = ''
#     recognition.lang = select_dialect.value
  $("#pegasus-microphone").on('click', (e) ->
    final_transcript = ''
    console.log 'mic clicked'
    $("#final_span").html('')
    $("interim_span").html('')
    $('.pegasus-input.long-pegasus-input').val('')
    $('.pegasus-input.long-pegasus-input').trigger('keyup')
    recognition.start()
    start_timestamp = e.timeStamp
  )
#     ignore_onend = false

else
  console.log 'Your browser does not support voice input, switch to Google Chrome!'