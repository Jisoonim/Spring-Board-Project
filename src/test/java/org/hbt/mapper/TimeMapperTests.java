package org.hbt.mapper;

import org.hbt.loading.LoadingTests;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;

import lombok.extern.log4j.Log4j;

@Log4j
public class TimeMapperTests extends LoadingTests {

	@Autowired
	private TimeMapper mapper;
	
	@Test
	public void testTime() {
		
		log.info(mapper.getTime1());
		log.info(mapper.getTime2());
	}
	
}
