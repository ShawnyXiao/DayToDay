# Spring Security OAuth 相关问题

最近使用了 Spring Security OAuth，这是其中被解决的一个问题。

## 问题

在 Authorization Sever 的配置中，注册 ClientDetails 是一项重要的步骤，而在注册 ClientDetails 中配置 Resource ID 有什么用处呢？也就是时常出现的这段代码：

```
@Override
public void configure(ClientDetailsServiceConfigurer clients) throws Exception {
	clients
		.inMemory()
			.withClient("clientapp")
				// 此处配置 secret, authorizedGrantTypes 和其他项
				.resourceIds(RESOURCE_ID)
}
```

## 答案

我在 OAuth2AuthenticationManager 类（该类负责对受保护资源的认证管理）的源码中发现了端倪。该类需要对传入的请求进行认证，而正是在认证的方法中存在对 Resource ID 的验证。它需要保证想要访问次资源的用户具有访问该资源的资格，相关部分的源码如下：

```
public Authentication authenticate(Authentication authentication) throws AuthenticationException {

	// 其他代码

	Collection<String> resourceIds = auth.getOAuth2Request().getResourceIds();
	if (resourceId != null && resourceIds != null && !resourceIds.isEmpty() && !resourceIds.contains(resourceId)) {
		throw new OAuth2AccessDeniedException("Invalid token does not contain resource id (" + resourceId + ")");
	}

	// 其他代码

}
```

此问题可以应用到这样的场景：

- Client 端假设有两种：移动端和 Web 端。移动端可以访问到 A 和 B 资源，而 Web 端只能访问 A 资源。那么可以为资源 A 配置 Resource ID 为 resourceA，为资源 B 配置 Resource ID 为 resourceB，这样做的话需要配置多个 Resource Server，可以参考此 [Demo of multiple Resource Servers](https://github.com/spring-projects/spring-security-oauth/tree/master/tests/annotation/multi)。然后为每个 Client 配置它能够访问到的资源，也就是：为移动端配置可以访问的 Resource ID 为 resourceA 和 resourceB；为 Web 端配置可以访问的 Resource ID 为 resourceA。