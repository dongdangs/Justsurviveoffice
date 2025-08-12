package com.spring.app.config;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import jakarta.persistence.EntityManagerFactory;

@Configuration  // Spring 컨테이너가 처리해주는 클래스로서, 클래스내에 하나 이상의 @Bean 메소드를 선언만 해주면 런타임시 해당 빈에 대해 정의되어진 대로 요청을 처리해준다.
@EnableTransactionManagement // 스프링 부트에서 Transaction 처리를 위한 용도
public class Datasource_Configuration {

	@Value("${mybatis.mapper-locations}")  // *.yml 파일에 있는 설정값을 가지고 온 것으로서 mapper 파일의 위치를 알려주는 것이다.
    private String mapperLocations;
	
 //	@Bean(name = "dataSource")  와  @Bean @Qualifier("dataSource") 은 같은 것이다.  
	@Bean
 	@Qualifier("dataSource")
    @ConfigurationProperties(prefix = "spring.datasource")
 // @Primary
    public DataSource dataSource(){
        return DataSourceBuilder.create().build();
    }
	
	
 // @Bean(name = "sqlSessionFactory") 또는 
    @Bean
    @Qualifier("sqlSessionFactory")
    @Primary
    public SqlSessionFactory sqlSessionFactory(@Qualifier("dataSource") DataSource dataSource, ApplicationContext applicationContext) throws Exception{ 
        SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
        sqlSessionFactoryBean.setDataSource(dataSource);
        sqlSessionFactoryBean.setConfigLocation(applicationContext.getResource("classpath:mybatis/mybatis-config.xml")); 
        sqlSessionFactoryBean.setMapperLocations(new PathMatchingResourcePatternResolver().getResources(mapperLocations));

        return sqlSessionFactoryBean.getObject();

    }

 // @Bean(name = "sqlsession") 또는 
    @Bean
    @Qualifier("sqlsession")
    @Primary
    public SqlSessionTemplate sqlSessionTemplate(@Qualifier("sqlSessionFactory") SqlSessionFactory sqlSessionFactory) {
        return new SqlSessionTemplate(sqlSessionFactory);
    }
    
    @Bean
    public PlatformTransactionManager transactionManager_mymvc_user() {
        DataSourceTransactionManager tm = new DataSourceTransactionManager();
        tm.setDataSource(dataSource());
        return tm;
    }
    
    

	// ====================== com.spring.app.config에 저희 mybatis 랑 JPA 프로젝트마다 2개의 클래스가 있는데 한개가 겹쳐서 해결법 찾는데 이렇게 추가하랍니다.(gpt)
	/*
	 * @Bean(name = "transactionManager") public PlatformTransactionManager
	 * transactionManager(EntityManagerFactory emf) { return new
	 * JpaTransactionManager(emf); }
	 */
	
    
	
}
