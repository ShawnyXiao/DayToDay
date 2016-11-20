# Spring Boot 最佳实践

## 使用一个支持依赖管理的构建系统，最好是Maven或Gradle。

1. 使用Maven，设置parent元素，使得项目继承自spring-boot-starter-parent。可以通过覆盖properties元素来覆盖个别的依赖。

2. 若不设置parent元素，可以设置dependency元素的scope元素为import的依赖：spring-boot-dependencies。可以通过在spring-boot-dependencies实体前插入一个节点，实现覆盖个别依赖。

3. 设置properties元素改变Java版本。

4. 使用Spring Boot Maven插件，将该插件添加到<plugins>节点处。

5. 在项目中包含spring-boot-starter-*依赖，来获取所有Spring及相关技术的一站式服务。

## 组织代码：

1. 遵循Java推荐的包命名规范，不使用“default”包（也就是不创建包）。

2. 将应用的Main类放在最高层的包（根级包）中，并将@EnableAutoConfiguration注解和@ComponentScan注解指定在Main类上。

## 使用基于Java的配置：

1. 不需要将所有的配置放进一个单独的指定了@Configuration注解的类，使用@Import注解或@ComponentScan注解导入其他配置类。

## Spring Boot自动配置尝试根据添加的jar依赖自动配置你的Spring应用。方法是：将@EnableAutoConfiguration注解或@SpringBootApplication注解指定到@Configuration类上。

1. 根据需要，你可以定义自己的配置类来替换自动配置的特定部分。若想查看应用启动了哪些自动配置项，可以在运行应用时打开debug开关，自动配置相关的日志会被输出到控制台。

2. 根据需要，你可以使用@EnabelAutoConfiguration注解的exclude属性或excludeName属性，禁用不想要的自动配置项。

## 假若你使用了建议的代码结构，那么可以随意使用@Component、@Service、@Repository、@Controller等注解定义beans，使用@Autowired注解注入依赖。

## 推荐使用@SpringBootApplication注解，它等价于同时使用@Configuration、@EnableAutoConfiguration、@ComponentScan注解。