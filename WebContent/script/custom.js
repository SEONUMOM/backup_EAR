/**
 * 
 */
$(function(){
	
	var status = false;
	var chId = '';
	var mouse_clicked = false;
	
	
	$('img.next_arrow').on({
		mouseenter: function(){},
		mouseleave: function(){},
		click: function(){
			chId =  $('#createChannelId').val();
			
			if(chId != ''){
				var appCallee;
				
				appCallee = new PlayRTC({
				      projectKey: '60ba608a-e228-4530-8711-fa38004719c1',
				      localMediaTarget: 'calleeLocalVideo',
				      remoteMediaTarget: 'calleeRemoteVideo',
				      ring: true
				});
				
				appCallee.getChannel(chId, function(data){
				 	console.log(data.channelId);
				 	console.log(data.peers);
				 	console.log(data.status);
				 	
				 	
				 	if (data.status!='nothing') {
				 		var form = document.getElementById("enter_form");
						form.submit();
					} else {
						alert("해당 채널이 존재하지 않습니다.");
					}
				 	
				}, function(xhr, res){
					alert("접속중에 오류가 발생하였습니다. 새로고침 후 다시 시도해주세요.");
				});
				
			} else {
				var form = document.getElementById("enter_form");
				form.submit();
			}
			
			}
			
			
	});
	
	
});