package org.hbt.mapper;

import org.apache.ibatis.annotations.Select;


public interface TimeMapper {

	@Select("select now()")
	public String getTime1();
	
	public String getTime2();
}
