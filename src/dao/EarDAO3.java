package dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;

import vo.Alphabet;
import vo.FingerData;

public class EarDAO3 {



	public FingerData find(FingerData data){
		SqlSession sqlSesstion = MybatisConfig.getSqlSessionFactory().openSession();

		//System.out.println(data);
		
		double gap = 100;
		FingerData finger = null;

		List<FingerData> resultList = sqlSesstion.selectList("test3.find1", data);
		/*for (FingerData x : resultList) {
			System.out.println("1차(검지):" + x);
		}*/
		//System.out.println("///////////////////////////////////");
		
		sqlSesstion.close();
		
		if (resultList.size()>1) {
			for (FingerData x : resultList) {
				double middle = Math.abs(x.getMiddle_x()-data.getMiddle_x())+Math.abs(x.getMiddle_y()-data.getMiddle_y())+Math.abs(x.getMiddle_z()-data.getMiddle_z());
				double ring = Math.abs(x.getRing_x()-data.getRing_x())+Math.abs(x.getRing_y()-data.getRing_y())+Math.abs(x.getRing_z()-data.getRing_z());
				double little = Math.abs(x.getLittle_x()-data.getLittle_x())+Math.abs(x.getLittle_y()-data.getLittle_y())+Math.abs(x.getLittle_z()-data.getLittle_z());
				double thumb = Math.abs(x.getThumb_x()-data.getThumb_x())+Math.abs(x.getThumb_y()-data.getThumb_y())+Math.abs(x.getThumb_z()-data.getThumb_z());
				double tmp = middle + ring + little + thumb;
				//System.out.println(tmp);
				if (tmp < gap) {
					gap = tmp;
					finger = x;
				}
			}
		}//if size first


		if (resultList.size()==1) {
			return resultList.get(0);
		}
		
		return finger;
	}//find

}//class
