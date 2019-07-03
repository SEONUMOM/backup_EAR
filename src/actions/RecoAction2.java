package actions;

import java.util.Map;

import org.apache.struts2.interceptor.SessionAware;

import com.opensymphony.xwork2.ActionSupport;

import dao.EarDAO2;
import dao.EarDAO3;
import vo.Alphabet;
import vo.FingerData;

public class RecoAction2 extends ActionSupport implements SessionAware{

	private Map<String, Object> session;

	private FingerData fingerdata;
	private Alphabet alphabet;
	private String channelId;


	/*public String find() throws Exception{
		EarDAO2 dao = new EarDAO2();
		alphabet = dao.find(fingerdata); //손가락 순차
		//alphabet = dao.search(fingerdata); //손가락 한번에 모두 다


		if (alphabet!=null) {
			if (session.containsKey("value")) {
					Alphabet value = (Alphabet) session.get("value");
				if (value.getLetter().equals(alphabet.getLetter())) {
					int cnt  = (int) session.get("cnt");
					if (cnt>2) {
						session.put("cnt", 0);
						return SUCCESS;
					} else {
						cnt++;
						session.put("cnt", cnt);
						alphabet = null;
						return SUCCESS;
					}
				}//equal letter
			}//containsKey
			session.put("value", alphabet);
			session.put("cnt", 1);
			alphabet=null;
		}//alphabet != null

		//System.out.println(session);

		return SUCCESS;
	}*/
	public String find() throws Exception{
		EarDAO3 dao = new EarDAO3();
		FingerData data = dao.find(fingerdata); //손가락 순차
		//alphabet = dao.search(fingerdata); //손가락 한번에 모두 다

		if (data!=null) {
			alphabet = new Alphabet(data.getLetter(), data.getDivision(), data.getIndicator());

			//System.out.println(alphabet);

			if (alphabet!=null) {
				if (session.containsKey("value")) {
					Alphabet value = (Alphabet) session.get("value");
					if (value.getLetter().equals(alphabet.getLetter())) {
						int cnt  = (int) session.get("cnt");
						if (cnt>1) {
							session.put("cnt", 0);
							return SUCCESS;
						} else {
							cnt++;
							session.put("cnt", cnt);
							alphabet = null;
							return SUCCESS;
						}
					}//equal letter
				}//containsKey
				session.put("value", alphabet);
				session.put("cnt", 0);
				alphabet=null;
			}//alphabet != null
		}
		//System.out.println(session);

		return SUCCESS;
	}


	public Map<String, Object> getSession() {
		return session;
	}

	@Override
	public void setSession(Map<String, Object> session) {
		this.session = session;
	}


	public FingerData getFingerdata() {
		return fingerdata;
	}

	public void setFingerdata(FingerData fingerdata) {
		this.fingerdata = fingerdata;
	}

	public Alphabet getAlphabet() {
		return alphabet;
	}

	public void setAlphabet(Alphabet alphabet) {
		this.alphabet = alphabet;
	}


	public String getChannelId() {
		return channelId;
	}


	public void setChannelId(String channelId) {
		this.channelId = channelId;
	}



}//class
