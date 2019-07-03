<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="css/FunctionPage.css">
<link rel="stylesheet" href="css/speech.css">
<link rel="stylesheet" href="css/sidevar.css">
<script src="script/jquery-3.1.0.min.js"></script>
    <script src="script/playrtc.min.js"></script>
    <script src="script/functionCustom.js"></script>
    <script src="script/nav.js"></script>
    
    <!-- text to voice -->
    <script src="script/voicerss-tts.min.js"></script>
    
    <!-- leap motion -->
	<script src="https://js.leapmotion.com/leap-0.6.3.min.js"></script>
	
	<script>
	
		// Store frame for motion functions
		var previousFrame = null;
		var paused = false;
		var pauseOnGesture = false;
	
		// Setup Leap loop with frame callback function
		var controllerOptions = {
			enableGestures : true
		};
	
		// to use HMD mode:
		// controllerOptions.optimizeHMD = true;
	
		var frameCopy;
		var fingerTypeMap = [ "Thumb", "Index finger", "Middle finger",
				"Ring finger", "Pinky finger" ];
	
		//store alphabet (division, indicator)
		var array = [];
		var han = '';
	
		var cho ='';
		var jun ='';
		var jon ='';
		var ac = false;
		
		var handType="";
		var timeId=''; 
		
		
		Leap.loop(controllerOptions, function(frame) {
			if (paused) {
				return; // Skip this update
			}
	
			// Display Hand object data
			if (frame.hands.length > 0) {
				for (var i = 0; i < frame.hands.length; i++) {
					var hand = frame.hands[i];
					handType = hand.type;
				} 
			// Store frame for motion functions
			} else {
				handType = "손 없음";
			}
			frameCopy = frame;
			previousFrame = frame;
			
		})//loop
	
		function vectorToString(vector, digits) {
			if (typeof digits === "undefined") {
				digits = 1;
			}
			var fingers = {
				x : vector[0].toFixed(digits),
				y : vector[1].toFixed(digits),
				z : vector[2].toFixed(digits)
			};
	
			return fingers;
		}
	
	
		$(function() {
			//이중자음 조합
			function doubIndex(a, b, i){
				if(a.indicator==0  &&b.indicator==9  ){//ㄳ0,9
						a.indicator= 2;
				}else if(a.indicator==2 &&b.indicator==12){//ㄵ 2,12
					a.indicator= 4;
				}else if(a.indicator==2 &&b.indicator==18){//ㄶ 2,18
					a.indicator= 5;
				}else if(a.indicator==5 &&b.indicator==0){//ㄺ 5,0
					a.indicator= 8;
				}else if(a.indicator==5 &&b.indicator==6){//ㄻ 5,6
					a.indicator=9 ;
				}else if(a.indicator==5 &&b.indicator==7){//ㄼ 5,7
					a.indicator= 10;
				}else if(a.indicator==5  &&b.indicator==18  ){//ㅀ 5,18
					a.indicator= 14;
				}else if(a.indicator== 7 &&b.indicator== 9 ){//ㅄ 7,9
					a.indicator=17 ;
				}
					$.extend(a,{"jj":"0"});
					array.splice(i,1);
			}	
			
			//줄임말
			function acronym(){
				if(array.length==2){
					var a =	array[0];
					var b =	array[1];
					if(a.division==1&&b.division==1){
						if(a.indicator==0&&b.indicator==9){//ㄱ ㅅ 감사 0,9
							han = '감사합니다.';	
						}else if(a.indicator==5&&b.indicator==11){//ㄹ ㅇ 레알 5,11
							han = '레알.';
						}else if(a.indicator==12&&b.indicator==9){//ㅈ ㅅ 죄송 12,9
							han = '죄송합니다.';
						}else if(a.indicator==11&&b.indicator==12){//ㅇ ㅈ  인정 11,12
							han ='인정.';
						}else if(a.indicator==11&&b.indicator==2){//ㅇ ㄴ 안녕 11, 2
							han = '안녕하세요.';
						}else if(a.indicator==0&&b.indicator==14){//ㄱ ㅊ 괜찮 0, 14
							han = '괜찮아요.';
						}
						$('p#singRecog').html(han); //test3에 글 찍기 
						rss();
						array=[];
						ac = true;
					}
				}
			}

			//자모음 조합
			function assemble() {
				acronym();
				if(ac==false){
				//쌍자음 구별하기 
				var sftAlphabet = {
					"division" : "1",
					"indicator" : "0"
				};
				for(var i = 0;i<array.length ; i++){
					if(array[i].division==2){
						array[i+1].indicator++; //쌍자음용 자음 (ㄱ,ㅅ,ㄷ,ㅈ,ㅂ) +1 하면 쌍자음의 인덱스
						array.splice(i,1); //sht 신호와 단자음 객체를 빼고 쌍자음의 indicator를 가진 sftAlphabet 객체를 추가
					}
					if(i<(array.length-1)&&array[i].division==0&&array[i+1].division==0){ //2 중 모음 거르기 
						var mo1 = array[i].indicator;
						var mo2 = array[i+1].indicator;
						if(mo1==8&&mo2==0){       //ㅗ ㅏ > ㅘ 
							array[i].indicator = 9;
						}else if(mo1==8&&mo2==1){ //ㅗ ㅐ > ㅙ
							array[i].indicator = 10;
						}else if(mo1==13&&mo2==4){ // ㅜ ㅓ > ㅝ
							array[i].indicator = 14;
						}else if(mo1==13&&mo2==5){ // ㅜ ㅔ > ㅞ 
							array[i].indicator = 15;
						}
						array.splice(i+1,1);
					}
				}			
				//그외의 종성들과 초성이 3개로 겹칠 때 
			var len = array.length;
			if(len>2){
				for(var i = 0;i<array.length-2 ; i++){
					var a = array[i];
					var b = array[i+1];
					var c = array[i+2];
					if((a.division==b.division&&a.division==c.division)){//쌍자음을 걸러낸 후에도 연속된 3개의 자음이 있으면 첫번 째 두번 째 자음을 합친 종성자음을 만든다. 
						ss=true;
					doubIndex(a,b,i+1);
					}			
				}
				
				//마지막이 이중자음일 때 
				var a = array[len-2];
				var b = array[len-1]; 
				if(a.division==b.division){
					doubIndex(a,b,len-1);
				}
			}
				//종성 넣기 - 마침표 액션 들어오면 실행
				var alphabet = {
					"division" : "0",
					"indicator" : "0"
				};
				for (var i = 1; i * 3 < array.length; i++) {
					var ii = i * 3 - 1;
					var iii = i * 3;
					var a = array[ii].division;
					var b = array[iii].division;
					if (a != b) {
						array.splice(i * 3 - 1, 0, alphabet);
					}
				}
				if (array.length % 3 != 0) {
					array.push(alphabet);
				}
				
				
				// 글 조합
				$.each(array, function(index, item) {
					var nokori = index % 3;
					if (nokori == 0) {
						cho = item.indicator;
					} else if (nokori == 1) {
						jun = item.indicator;
					} else if (nokori == 2) {
						jon = item.indicator;
						var gy = item.division;
						if(item.jj!="0"){
						if(jon==2){jon++;} //ㄴ
						else if(jon==3){jon+=3;}//ㄷ
						else if(jon==5){jon+=2;}//ㄹ
						else if(jon>=6&&12>=jon){jon+=9;}//ㅁ,ㅂ,ㅅ,ㅇ,ㅈ
						else if(jon>=14&&18>=jon){jon+=8;}//ㅊ,ㅋ,ㅌ,ㅍ,ㅎ
						}
						cho *= 1;
						jun *= 1;
						jon *= 1;
						if(jon!=0){jon++;}
						if(jon==0&&gy==1){jon++;} //종성 ㄱ 일 때 
						var temp = (0xAC00 + 28 * 21 * (cho) + 28 * (jun) + (jon));
						han += String.fromCharCode(temp);
					}
				});
				if (han.length>0) {
					$('p#singRecog').html(han); //글 찍기 
					rss();
				}
				array=[];
				}
				ac=false;
			}// 글자 보이기 
	
			//조합된 글 목소리로! 
			function rss() {
				VoiceRSS.speech({
					key : '2330e4438d154c34803f4f4e72f066fa',
					src : han,
					hl : 'ko-kr',
					r : 0,
					c : 'mp3',
					f : '44khz_16bit_stereo',
					ssml : false
				});
				han='';
			}
			
			
			setInterval(function() {
				if (timeId=='') {
					timeId = setInterval(recog, 250);
				} 
			}, 250);
			
			
			function recog() {
				
				if (handType == 'right') {
					$("#handType").text("오른손");
					
					var coordinates = [];
	
					for (var i = 0; i < frameCopy.pointables.length; i++) {
						var pointable = frameCopy.pointables[i];
						coordinates[i] = {
							type : fingerTypeMap[pointable.type],
							direction : vectorToString(pointable.direction)
						}
					}
					
					var temp = {
						"fingerdata.thumb_x" : coordinates[0].direction.x,
						"fingerdata.thumb_y" : coordinates[0].direction.y,
						"fingerdata.thumb_z" : coordinates[0].direction.z,
						"fingerdata.index_x" : coordinates[1].direction.x,
						"fingerdata.index_y" : coordinates[1].direction.y,
						"fingerdata.index_z" : coordinates[1].direction.z,
						"fingerdata.middle_x" : coordinates[2].direction.x,
						"fingerdata.middle_y" : coordinates[2].direction.y,
						"fingerdata.middle_z" : coordinates[2].direction.z,
						"fingerdata.ring_x" : coordinates[3].direction.x,
						"fingerdata.ring_y" : coordinates[3].direction.y,
						"fingerdata.ring_z" : coordinates[3].direction.z,
						"fingerdata.little_x" : coordinates[4].direction.x,
						"fingerdata.little_y" : coordinates[4].direction.y,
						"fingerdata.little_z" : coordinates[4].direction.z
	
					};
	
					temp = JSON.stringify(temp);
					temp = JSON.parse(temp);
	
					$.ajaxSettings.traditional = true;
					$.ajax({
						url : 'find',
						method : 'post',
						data : temp,
						dataType : 'json',
						success : function(resp) {
							var alphabet = resp.alphabet;
							// 			var division = resp.alphabet.division;
							// 			var indicator = resp.alphabet.indicator;
							/* 		
								배열에 넣기.
								alphabet.division // 구분자
								alphabet.indicator // index
							 */
							 if (alphabet!=null) {
								array.push(alphabet);
								$('p#singRecog').html(function(index, html) {
									return html += alphabet.letter;
								});
							}
						}//success
						,
						error : function() {
							
						}//error
	
					});//ajax
					
				}//if rightHand
				else if (handType == 'left') {
					$("#handType").text("왼손");
					var gestureType = "";
					if (frameCopy.gestures.length > 0) {
					    for (var i = 0; i < frameCopy.gestures.length; i++) {
					      var gesture = frameCopy.gestures[i];
					 		gestureType = gesture.type;
					 }
					}
					switch (gestureType) {
					case "circle":
						/* 
							오타 삭제 내용;
						 */
						 array.splice(array.length-1,1);
						 $('p#singRecog').html(function(index, html) {
								return html.substring(0,html.length-1);
							});
						clearInterval(timeId);
						timeId='';
						break;
					case "swipe":
						if (array.length>=3) {
							var endDivision = array[array.length-1].division;
							if (endDivision==3) {
								array.pop();
								if (array.length>=2) {
									assemble();
									clearInterval(timeId);
									timeId='';
								}//if
							}//if
						}//if
						break;
					}//switch */
	
				}//if leftHand
				else {
					$("#handType").text("손 없음");
					clearInterval(timeId);
					timeId='';
				}
			}//recog
		});
		
</script>

<!-- speech script start -->
<script>
(function(e, p){
    var m = location.href.match(/platform=(win8|win|mac|linux|cros)/);
    e.id = (m && m[1]) ||
           (p.indexOf('Windows NT 6.2') > -1 ? 'win8' : p.indexOf('Windows') > -1 ? 'win' : p.indexOf('Mac') > -1 ? 'mac' : p.indexOf('CrOS') > -1 ? 'cros' : 'linux');
    e.className = e.className.replace(/\bno-js\b/,'js');
  })(document.documentElement, window.navigator.userAgent)
</script>
<meta charset="utf-8">
<meta content="initial-scale=1, minimum-scale=1, width=device-width" name="viewport">
<meta content=
"Google Chrome is a browser that combines a minimal design with sophisticated technology to make the web faster, safer, and easier."
name="description">

<link href="https://plus.google.com/100585555255542998765" rel="publisher">
<link href="//www.google.com/images/icons/product/chrome-32.png" rel="icon" type="image/ico">
<script src="//www.google.com/js/gweb/analytics/autotrack.js"/></script>
<script src="//www.google.com/js/gweb/analytics/doubletrack.js"></script>

<script>
	new gweb.analytics.AutoTrack({
		profile: 'UA-26908291-1'
    });
</script>

<script>
	$(function(){
		var icon_click = 0;
		
		$('#icon1').on('click', function(){
			if(icon_click == 0){
				$('#side1').css('display', 'block');	
				icon_click = 1;
			}
			else {
				$('#side1').css('display', 'none');
				icon_click = 0;
			}
		});
		
		
		
		
	});
</script>
<!-- speech script end -->



<!-- Side Nav에 들어갈 내용 -->
    
</head>
<body>
<div id="wrapper">
	
	<form id="end_skype" action="end_skype.action">
	</form>
	<!-- 화상화면 나오는 곳 -->	
	<div id="left_block">
		<s:textfield id="createChannelId" name="channelId" />
      	<span id="viewingId"></span>
		<video class="remote-video center-block" id="callerRemoteVideo"></video>
		<video class="remote-video center-block" id="calleeRemoteVideo"></video>
		
		<video class="local-video pull-right" id="callerLocalVideo"></video>
		<video class="local-video pull-right" id="calleeLocalVideo"></video>
	</div>
	
	
	
	
	<!-- 우측 주요 기능 나오는 곳 -->
	<div class="container">
        <div class="breadcrumbs">
			<ul class="social"></ul>
		</div>
			
			<ul class="tl-menu">
				<li><a href="#" class="nav0">Logo</a></li>
				<li><a href="#" class="nav1" id="navItem1">Option 1</a></li>
				<li><a href="#" class="nav2" id="navItem2">Option 2</a></li>
				<li><a href="#" class="nav3" id="navItem3">Option 3</a></li>
				<!-- <li><a href="#" class="icon-chart" id="navItem6">Option 2</a></li>
				<li class="tl-current">
          		<a href="#" class="icon-download" id="navItem4">Active</a></li>
				<li><a href="#" class="icon-flag" id="navItem5">Option 4</a></li>
				
				<li><a href="#" class="icon-file" id="navItem7">Option 6</a></li> -->
			</ul>
			
		<!--Slider Nav 1-->
        <nav class="slider-menu slider-menu-vertical slider-menu-left" id="slider-menu-s1">
			    <h3>수화통역</h3>
			    
			    <span id="handType">수화 내용</span>
				<p id="singRecog"></p>
		
				<div class="compact marquee-stacked" id="marquee">
				      <div class="marquee-copy"></div>
				      </div>
				   
				<div id="results">
				      <span class="final" id="final_span"></span> <span class="interim" id="interim_span"></span>
				</div>

				<div class="compact marquee" id="div_language">
				<select id="select_language" onchange="updateCountry()"></select>&nbsp;&nbsp; 
				<select id="select_dialect"></select>
				</div>

				<!-- speech script import -->
				<script type="text/javascript" src="script/speech.js"></script>
		</nav>
		
		<!--Slider Nav 2-->
        <nav class="slider-menu slider-menu-vertical slider-menu-left" id="slider-menu-s2">
			    <h3>사용법</h3>
			    
				<div id="howToUse">
					<img src="img/howToUse1.png"/>
				</div>  
				
		</nav>
		
	</div>
	<script>
			var menuLeft = document.getElementById( 'slider-menu-s1' ),
				menuLeft1 = document.getElementById('slider-menu-s2'),
				showLeft = document.getElementById( 'showLeft' ),
				body = document.body;

			navItem1.onclick = function() {
				classie.toggle( this, 'active' );
				classie.toggle( menuLeft, 'slider-menu-open' );
				disableOther( 'navItem1' );
			};
      
			navItem2.onclick = function() {
				classie.toggle( this, 'active' );
				classie.toggle( menuLeft1, 'slider-menu-open' );
				disableOther( 'navItem2' );
			};

			function disableOther( button ) {
				if( button !== 'showLeft' ) {
					classie.toggle( showLeft, 'disabled' );
				}
			}
	</script>
	
	
	
	<!--  -->


</div><!-- wrapper -->

</body>
</html>