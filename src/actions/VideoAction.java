package actions;

import com.opensymphony.xwork2.ActionSupport;

public class VideoAction extends ActionSupport{

	private String channelId;
	
	public String startCall(){
		//System.out.println("channelId : " + channelId);
		return SUCCESS;
	}

	public String getChannelId() {
		return channelId;
	}

	public void setChannelId(String channelId) {
		this.channelId = channelId;
	}

	

}
