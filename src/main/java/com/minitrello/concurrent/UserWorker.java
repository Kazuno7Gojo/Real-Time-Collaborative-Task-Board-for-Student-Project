package com.minitrello.concurrent;

import com.minitrello.model.User;

import java.util.concurrent.atomic.AtomicBoolean;

public class UserWorker implements Runnable {
    private final User user;
    private final AtomicBoolean running = new AtomicBoolean(false);
    private Thread thread;

    public UserWorker(User user) {
        this.user = user;
    }

    public synchronized void start() {
        if (running.get()) return;
        running.set(true);
        thread = new Thread(this, "UserWorker-" + user.getId());
        thread.setDaemon(true);
        thread.start();
    }

    public synchronized void stop() {
        running.set(false);
        if (thread != null) {
            thread.interrupt();
        }
    }

    @Override
    public void run() {
        try {
            while (running.get()) {
                // Placeholder: perform user-specific background tasks
                // e.g., polling notifications, cleaning up temp data, etc.
                Thread.sleep(2000);
            }
        } catch (InterruptedException ignored) {
            // allow graceful shutdown
        } finally {
            running.set(false);
        }
    }
}