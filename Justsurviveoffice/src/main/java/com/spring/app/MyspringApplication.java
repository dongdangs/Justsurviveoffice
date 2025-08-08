package com.spring.app;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.scheduling.annotation.EnableScheduling;

// 프로젝트명+Application 으로 되어진 클래스가 프로젝트가 동작할 수 있게 해주는 시작점인 메인 클래스 파일이다. 
// 이 클래스에는 @SpringBootApplication 어노테이션이 붙어있는데  @SpringBootApplication 어노테이션 속에는 
// @ComponentScan, @SpringBootConfiguration, @EnableAutoConfiguration 등이 들어있기에 이러한 여러 어노테이션들이 다같이 사용되어진다.  
// @SpringBootApplication 어노테이션 속에 포함된 @ComponentScan 어노테이션의 기능은  
// 프로젝트명+Application 클래스의 base-package 인 "com.spring.app" 및 그 하위(자식) package 에 있는 여러개의 클래스들 중 
// @Component 어노테이션이 붙어있는 클래스들은 bean 으로 만들어 주는데 이러한 bean 들을 모두 스캔해서 읽어오는 기능을 해주는 것이다.
@SpringBootApplication
@EnableAspectJAutoProxy  // Application 클래스에 @EnableAspectJAutoProxy 를 추가하여 AOP(Aspect Oriented Programming)클래스를 찾을 수 있게 해준다. 우리는 com.spring.app.aop.CommonAop 이 AOP 클래스 이다.
@EnableScheduling 		 // 스프링 스케줄러 기능을 사용하도록 해주는 것이다.
public class MyspringApplication {

	public static void main(String[] args) {
		SpringApplication.run(MyspringApplication.class, args);
	}
	/*
	   스프링부트 애플리케이션은 내장 WAS(Tomcat, Jetty, Undertow 등)를 구동시켜 사용할 때 main() 메소드를 시작진입점으로 사용한다.
       이 main() 메소드 속에는 SpringApplication.run() 메소드를 호출하여 실행시키는데, 이 메소드의 기능은 해당 프로젝트 웹 애플리케이션을 실행하는데 필요한 빈들을 스캔하고 구성해주는 것이다. 
	*/
}
