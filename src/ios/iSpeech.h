
#import <Cordova/CDV.h>
#import "iSpeechSDK.h"

@interface iSpeech : CDVPlugin <ISSpeechSynthesisDelegate,ISSpeechRecognitionDelegate>

-(void)init:(CDVInvokedUrlCommand*)command;
-(void)speak:(CDVInvokedUrlCommand*)command;
-(void)recognize:(CDVInvokedUrlCommand*)command;

@end
