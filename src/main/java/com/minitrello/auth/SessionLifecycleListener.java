package com.minitrello.auth;

import com.minitrello.concurrent.UserWorker;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;

@WebListener
public class SessionLifecycleListener implements HttpSessionListener {
    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        Object w = se.getSession().getAttribute("userWorker");
        if (w instanceof UserWorker) {
            ((UserWorker) w).stop();
        }
    }
}