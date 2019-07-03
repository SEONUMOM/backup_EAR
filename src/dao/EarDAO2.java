package dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;

import vo.Alphabet;
import vo.FingerData;

public class EarDAO2 {

	public Alphabet find(FingerData data){
		SqlSession sqlSesstion = MybatisConfig.getSqlSessionFactory().openSession();
		

		List<Alphabet> resultList = sqlSesstion.selectList("test2.find1", data);

		if (resultList.size()>1) {

			HashMap<String, Object> hashmap = new HashMap<>();
			hashmap.put("data", data);
			hashmap.put("list", resultList);
			resultList = sqlSesstion.selectList("test2.find2", hashmap);
			if (resultList.size()>1) {
				hashmap.put("list", resultList);
				resultList = sqlSesstion.selectList("test2.find3", hashmap);
				if (resultList.size()>1) {
					hashmap.put("list", resultList);
					resultList = sqlSesstion.selectList("test2.find4", hashmap);
					if (resultList.size()>1) {
						hashmap.put("list", resultList);
						resultList = sqlSesstion.selectList("test2.find5", hashmap);
					}//if size four-th
				}//if size third	
			}//if size second
		}//if size first

		sqlSesstion.close();
		
		if (resultList.size()==1) {
			return resultList.get(0);
		} else {
			return null;
		}
	}//find
	
	
	public Alphabet search(FingerData data){
		SqlSession sqlSesstion = MybatisConfig.getSqlSessionFactory().openSession();

		Alphabet result = sqlSesstion.selectOne("test2.search", data);
		
		sqlSesstion.close();
		return result;
	}
}//class
