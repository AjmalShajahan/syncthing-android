package com.ajmalshajahan.syncthingandroid;

import com.ajmalshajahan.syncthingandroid.activities.FirstStartActivity;
import com.ajmalshajahan.syncthingandroid.activities.FolderPickerActivity;
import com.ajmalshajahan.syncthingandroid.activities.MainActivity;
import com.ajmalshajahan.syncthingandroid.activities.SettingsActivity;
import com.ajmalshajahan.syncthingandroid.activities.ShareActivity;
import com.ajmalshajahan.syncthingandroid.activities.ThemedAppCompatActivity;
import com.ajmalshajahan.syncthingandroid.receiver.AppConfigReceiver;
import com.ajmalshajahan.syncthingandroid.service.RunConditionMonitor;
import com.ajmalshajahan.syncthingandroid.service.EventProcessor;
import com.ajmalshajahan.syncthingandroid.service.NotificationHandler;
import com.ajmalshajahan.syncthingandroid.service.RestApi;
import com.ajmalshajahan.syncthingandroid.service.SyncthingRunnable;
import com.ajmalshajahan.syncthingandroid.service.SyncthingService;
import com.ajmalshajahan.syncthingandroid.util.Languages;

import javax.inject.Singleton;

import dagger.Component;

@Singleton
@Component(modules = {SyncthingModule.class})
public interface DaggerComponent {

    void inject(SyncthingApp app);
    void inject(MainActivity activity);
    void inject(FirstStartActivity activity);
    void inject(FolderPickerActivity activity);
    void inject(Languages languages);
    void inject(SyncthingService service);
    void inject(RunConditionMonitor runConditionMonitor);
    void inject(EventProcessor eventProcessor);
    void inject(SyncthingRunnable syncthingRunnable);
    void inject(NotificationHandler notificationHandler);
    void inject(AppConfigReceiver appConfigReceiver);
    void inject(RestApi restApi);
    void inject(SettingsActivity.SettingsFragment fragment);
    void inject(ShareActivity activity);
    void inject(ThemedAppCompatActivity activity);
}
