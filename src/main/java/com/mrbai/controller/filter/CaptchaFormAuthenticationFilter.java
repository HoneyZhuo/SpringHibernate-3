package com.mrbai.controller.filter;

import com.google.code.kaptcha.Constants;
import com.mrbai.controller.exception.IncorrectCaptchaException;
import com.mrbai.shiro.CaptchaUsernamePasswordToken;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.RememberMeAuthenticationToken;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.filter.authc.FormAuthenticationFilter;
import org.apache.shiro.web.util.WebUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by MirBai
 * on 2016/5/2.
 */
public class CaptchaFormAuthenticationFilter extends FormAuthenticationFilter {

    private static final Logger LOGGER = LoggerFactory.getLogger(CaptchaFormAuthenticationFilter.class);
    public CaptchaFormAuthenticationFilter() {

    }

    /**
     *  @Author 白景川【baijc1234@126.com】
     *  @Date 2016/5/2 18:38
     *  @TODO 登录验证
     *  @notice 
     */
    @Override
    protected boolean executeLogin(ServletRequest request, ServletResponse response) throws Exception {
        CaptchaUsernamePasswordToken token = createToken(request, response);
        try {
            /*图形验证码验证*/
            doCaptchaValidate((HttpServletRequest) request, token);
            Subject subject = getSubject(request, response);
            subject.login(token);
            String host =  token.getHost();
            LOGGER.info(token.getUsername() + "====登录成功====", host);
            return onLoginSuccess(token, subject, request, response);
        } catch (AuthenticationException e) {
            LOGGER.info(token.getUsername() + "登录失败===" + e);
            return onLoginFailure(token, e, request, response);
        }
    }

    /**
     *  @Author 白景川【baijc1234@126.com】
     *  @Date 2016/5/2 18:30
     *  @TODO 验证码校验
     *  @notice
     */
    protected void doCaptchaValidate(HttpServletRequest request, CaptchaUsernamePasswordToken token){
        String captcha = (String) request.getSession().getAttribute(Constants.KAPTCHA_SESSION_KEY);
        if (captcha != null && !captcha.equalsIgnoreCase(token.getCaptcha())){
            throw new IncorrectCaptchaException("验证码不正确");
        }
    }
    /*将session中的请求地址设置为空，让shiro使用我们配置的successUrl*/
    @Override
    protected void issueSuccessRedirect(ServletRequest request, ServletResponse response) throws Exception {
        String successUrl = getSuccessUrl();
        WebUtils.issueRedirect(request, response, successUrl, null, true);
    }

    @Override
    protected CaptchaUsernamePasswordToken createToken(ServletRequest request, ServletResponse response) {
        String account = getUsername(request);
        String password = getPassword(request);
        String captcha = getCaptcha(request);
        boolean rememberMe = isRememberMe(request);
        String host = getHost(request);
        return new CaptchaUsernamePasswordToken(account, password, captcha,rememberMe, host);
    }

    public static final String DEFAULT_CAPTCHA_PARAM = "captcha";

    private String captchaParam = DEFAULT_CAPTCHA_PARAM;

    public String getCaptchaParam() {
        return captchaParam;
    }

    public void setCaptchaParam(String captchaParam) {
        this.captchaParam = captchaParam;
    }

    protected String getCaptcha(ServletRequest request){
        return WebUtils.getCleanParam(request,getCaptchaParam());
    }

    //保存异常对象到request
    @Override
    protected void setFailureAttribute(ServletRequest request, AuthenticationException ae) {
        super.setFailureAttribute(request, ae);
    }
}
