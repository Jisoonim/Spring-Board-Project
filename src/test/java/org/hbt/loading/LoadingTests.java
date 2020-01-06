package org.hbt.loading;

import static org.junit.Assert.assertNotNull;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class LoadingTests {
	@Autowired
	private ApplicationContext ctx;

	@Test
	public void testLog() {
		log.info("log......................");
	}

	@Test
	public void testCtx() {
		log.info(ctx);
		assertNotNull(ctx);
	}

}
