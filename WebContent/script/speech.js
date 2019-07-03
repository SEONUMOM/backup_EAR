window.___gcfg = { lang: 'en' };
  (function() {
    var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
    po.src = 'https://apis.google.com/js/plusone.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
  })();

var langs =
[['한국어', ['ko-KR']]];

for (var i = 0; i < langs.length; i++) {
  select_language.options[i] = new Option(langs[i][0], i);
}
select_language.selectedIndex = 0;
select_language.style.visibility = 'hidden';
select_dialect.style.visibility = 'hidden';
select_dialect.selectedIndex = 0;

var final_transcript = '';
var recognizing = false;
var ignore_onend;
var start_timestamp;
if (!('webkitSpeechRecognition' in window)) {
  upgrade();
} else {
	 
  var recognition = new webkitSpeechRecognition();
  recognition.continuous = true;
  recognition.interimResults = true;

  recognition.onstart = function() {
    recognizing = true;
  }; 

  recognition.onend = function() {
    recognizing = false;
    if (ignore_onend) {
      return;
    }

    if (!final_transcript) {
      return;
    }

    if (window.getSelection) {
      window.getSelection().removeAllRanges();
      var range = document.createRange();
      range.selectNode(document.getElementById('final_span'));
      window.getSelection().addRange(range);
    }
  };

  recognition.onresult = function(event) {
    var interim_transcript = '';
    if (typeof(event.results) == 'undefined') {
      recognition.onend = null;
      recognition.stop();
      upgrade();
      return;
    }
    for (var i = event.resultIndex; i < event.results.length; i++) {
      if (event.results[i].isFinal) {
        final_transcript = event.results[i][0].transcript;
      } else {
        interim_transcript = event.results[i][0].transcript;
      }
    }
    final_transcript = capitalize(final_transcript);
    final_span.innerHTML = linebreak(final_transcript);
    interim_span.innerHTML = linebreak(interim_transcript);
    if (final_transcript || interim_transcript) {
      showButtons('inline-block');
    }
  };
}

var two_line = /\n\n/g;
var one_line = /\n/g;
function linebreak(s) {
  return s.replace(two_line, '<p></p>').replace(one_line, '<br>');
}

var first_char = /\S/;
function capitalize(s) {
  return s.replace(first_char, function(m) { return m.toUpperCase(); });
}

function startButton(event) {
   if (recognizing) {
    recognition.stop();
    return;
  } 
  final_transcript = '';
  recognition.lang = select_dialect.value;
  recognition.start();
  
  ignore_onend = false;
  final_span.innerHTML = ''; //검은색 글씨로 나오는 부분
  interim_span.innerHTML = ''; //회색 글씨로 나오는 부분
  showButtons('none');
}

var current_style;
function showButtons(style) {
  if (style == current_style) {
    return;
  }
  current_style = style;
}
////////////////////상직
$(function(){
	var pre_contents = "";
	setInterval(function(){
		startButton(event);
		var contents = $('span#final_span').text();
		if (pre_contents == contents) {
			$('span#final_span').text("");
		}
		else {
			pre_contents = contents;
		}
	}, 3000);

});