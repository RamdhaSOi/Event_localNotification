//
//  ViewController.m
//  Event_localNotification
//
//  Created by Ramdhas on Jun,10.
//  Copyright (c) 2014 Ramdhas. All rights reserved.
//

#import "ViewController.h"
#import <EventKit/EventKit.h>  //Its must
#import <EventKitUI/EventKitUI.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)AddEventAction:(id)sender
{
//    NSString *dateString = @"10-Jun-14 04:50 PM";
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"dd-MMM-yy HH:mm a" options:0 locale:[NSLocale currentLocale]]];
//    
    NSDate *date = [NSDate date];
    
    EKEventStore *eventStore=[[EKEventStore alloc] init];
    
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
             NSString * EventDetail = @"Event Detail";
             event.title =@"Sample Event & Notification App";
             event.startDate=date;
             event.endDate=date;
             event.notes = EventDetail;
             event.allDay=YES;
             
             [event setCalendar:[eventStore defaultCalendarForNewEvents]];
             
             NSError *err;
             [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
         }
         else
         {
             NSLog(@"NoPermission to access the calendar");
         }
     }];
    
    UIAlertView * Alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Your Event added successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil , nil];
    [Alert show];
    
    
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    Class cls = NSClassFromString(@"UILocalNotification");
    if (cls != nil)
    {
        UILocalNotification *notif = [[cls alloc] init];
        notif.fireDate = date;
        notif.timeZone = [NSTimeZone defaultTimeZone];
        notif.repeatInterval=NSMinuteCalendarUnit;
        notif.alertBody = @"Your Notification";
        notif.alertAction = @"Ramdy";
        notif.soundName = UILocalNotificationDefaultSoundName;
        notif.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:notif];
    }
    
    

}
@end
