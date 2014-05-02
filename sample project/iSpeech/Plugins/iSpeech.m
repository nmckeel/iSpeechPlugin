//
//  TTSAndSpeechRecognitionPlugin.m
//  TTSPlugin
//
//  Created by Admin on 30/04/13.
//
//

#import "iSpeech.h"
#import "ISSpeechSynthesis.h"
#import "ISSpeechRecognition.h"


@implementation iSpeech


-(void)init:(CDVInvokedUrlCommand *)command {
    
    NSString* key = [command.arguments objectAtIndex:0];
    iSpeechSDK *sdk = [iSpeechSDK sharedSDK];
    sdk.APIKey = key;
}

-(void)speak:(CDVInvokedUrlCommand*)command {
    
    CDVPluginResult* pluginResult = nil;
    NSString* text = [command.arguments objectAtIndex:0];
    
    if (text != nil) {
        
        ISSpeechSynthesis *synthesis = [[ISSpeechSynthesis alloc] initWithText:text];
        /* Configuration changes here: */
        //[synthesis setVoice:ISVoiceEURSpanishMale];
        //[synthesis setBitrate:48];
        //[synthesis setSpeed:0];
        
        [synthesis setDelegate:self];
        

        [synthesis speakWithHandler:^(NSError *error, BOOL userCancelled) {
            if (!error&&!userCancelled) {
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
            }
            if (error) {
                 [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"error"] callbackId:command.callbackId];
            }
            if (userCancelled) {
                 [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"user cancelled"] callbackId:command.callbackId];
            }
        }];
        
        
    } else {
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"no text"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        
    }
    
    
    
}

- (void)recognize:(CDVInvokedUrlCommand*)command {
    ISSpeechRecognition *recognition = [[ISSpeechRecognition alloc] init];
    [recognition setDelegate:self];
    [recognition setSilenceDetectionEnabled:YES];
    //[recognition setLocale:ISLocaleESSpanish];
    [recognition setFreeformType:ISFreeFormTypeDictation];
    
    [recognition listenAndRecognizeWithTimeout:10 handler:^(NSError *error, ISSpeechRecognitionResult *result, BOOL cancelledByUser) {
        
        if (cancelledByUser) {
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"cancel"] callbackId:command.callbackId];
        } else {
            if(!error){
                if (result.confidence < 0.3) {
                    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"no confidence"] callbackId:command.callbackId];
                } else {
                    [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result.text] callbackId:command.callbackId];
                }
                
            } else {
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"error"] callbackId:command.callbackId];
            }
        }
        
        
        
    }];
    
}

@end
