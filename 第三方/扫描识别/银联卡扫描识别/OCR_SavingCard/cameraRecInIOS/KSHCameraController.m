
#import <UIKit/UIKit.h>
#import "KSHCameraController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "KSHContextManager.h"
#import "exbankcard.h"
#import "BinCodeSearch.h"

/////////////////////////////////////////////////////////
int  nType = 0;
int  nRate = 0;
int  nCharNum = 0;
char szBankName[128];
char numbers[256];
CGRect rects[64];
CGRect subRect;

/////////////////////////////////////////////////////////
//@import CoreImage;


@interface KSHCameraController () <AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate,AVCaptureMetadataOutputObjectsDelegate>
{
    BOOL bInProcessing;
    BOOL bHasResult;
    BOOL bFirstTime;
}

@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (weak, nonatomic) AVCaptureDeviceInput *activeVideoInput;

@property (strong, nonatomic) AVCaptureStillImageOutput *imageOutput;
@property (strong, nonatomic) AVCaptureVideoDataOutput *videoDataOutput;
@property (strong, nonatomic) AVCaptureAudioDataOutput *audioDataOutput;
@property (strong, nonatomic) AVCaptureMetadataOutput *medaDataOutput;
@property (strong, nonatomic) AVAssetWriter *assetWriter;
@property (strong, nonatomic) AVAssetWriterInput *assetWriterVideoInput;
@property (strong, nonatomic) AVAssetWriterInputPixelBufferAdaptor *assetWriterInputPixelBufferAdaptor;
@property (strong, nonatomic) AVAssetWriterInput *assetWriterAudioInput;
@property (strong, nonatomic) NSMutableDictionary *videoSettings;
@property (strong, nonatomic) NSDictionary *audioSettings;
@property (strong, nonatomic) dispatch_queue_t captureQueue;
@property (assign, nonatomic) CMTime startTime;
@property (assign, nonatomic) BOOL isWriting;
@property (assign, nonatomic) BOOL firstSample;
@property (strong, nonatomic) NSURL *outputURL;

@property (nonatomic, assign, readwrite) NSTimeInterval recordedDuration;

@property (nonatomic, strong) NSArray *faceObjects;

@property (nonatomic, strong) CIFilter *filter;
@property (nonatomic, strong) CIContext *ciContext;
@property (nonatomic, strong) EAGLContext *eaglContext;

@end

@implementation KSHCameraController
- (void)resetRecParams
{
    bInProcessing = NO;
    bHasResult = NO;
    if ([self.captureSession canAddOutput:self.videoDataOutput]) {
        [self.captureSession addOutput:self.videoDataOutput];
        NSLog(@"captureSession addOutput");
    }

}

- (BOOL)setupSession:(NSError **)error {
    bInProcessing = NO;
    bHasResult = NO;
    bFirstTime = YES;
    self.bShowCutImg = NO;
    
    self.filterEnable = YES;
    self.filter = [CIFilter filterWithName:@"CIPixellate"];
    self.eaglContext = [KSHContextManager sharedInstance].eaglContext;
    self.ciContext = [KSHContextManager sharedInstance].ciContext;

    
    // Dispatch Setup
    self.captureQueue = dispatch_queue_create("com.kimsungwhee.mosaiccamera.videoqueue", NULL);
	self.captureSession = [[AVCaptureSession alloc] init];
	[self.captureSession beginConfiguration];
	self.captureSession.sessionPreset = self.sessionPreset;

	// Set up default camera device
	AVCaptureDevice *videoDevice =
	    [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

	AVCaptureDeviceInput *videoInput =
	    [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:error];
	if (videoInput) {
		if ([self.captureSession canAddInput:videoInput]) {
			[self.captureSession addInput:videoInput];
			self.activeVideoInput = videoInput;
		}
	}
	else {
		return NO;
	}

	// Setup default microphone
//	AVCaptureDevice *audioDevice =
//	    [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
//
//	AVCaptureDeviceInput *audioInput =
//	    [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:error];
//	if (audioInput) {
//		if ([self.captureSession canAddInput:audioInput]) {
//			[self.captureSession addInput:audioInput];
//		}
//	}
//	else {
//		return NO;
//	}
    //Meta data
    /*
    self.medaDataOutput = [[AVCaptureMetadataOutput alloc] init];
    if ([self.captureSession canAddOutput:self.medaDataOutput]) {
        [self.captureSession addOutput:self.medaDataOutput];
        
        self.medaDataOutput.metadataObjectTypes = @[AVMetadataObjectTypeFace];
        [self.medaDataOutput setMetadataObjectsDelegate:self queue:self.captureQueue];
        
    }
*/
	// Setup the still image output
//	self.imageOutput = [[AVCaptureStillImageOutput alloc] init];
//	self.imageOutput.outputSettings = @{ AVVideoCodecKey : AVVideoCodecJPEG };
//
//	if ([self.captureSession canAddOutput:self.imageOutput]) {
//		[self.captureSession addOutput:self.imageOutput];
//	}


	//VideoOutput Setup
	self.videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
	self.videoDataOutput.alwaysDiscardsLateVideoFrames = YES;
	[self.videoDataOutput setSampleBufferDelegate:self queue:self.captureQueue];

	self.videoDataOutput.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
	                                      [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange], (id)kCVPixelBufferPixelFormatTypeKey,
	                                      nil];


	if ([self.captureSession canAddOutput:self.videoDataOutput]) {
		[self.captureSession addOutput:self.videoDataOutput];
	}
	else {
		return NO;
	}

	//AudioOutpu Setup
//	self.audioDataOutput = [[AVCaptureAudioDataOutput alloc] init];
//	[self.audioDataOutput setSampleBufferDelegate:self queue:self.captureQueue];
//
//	if ([self.captureSession canAddOutput:self.audioDataOutput]) {
//		[self.captureSession addOutput:self.audioDataOutput];
//	}
//	else {
//		return NO;
//	}
    
    AVCaptureConnection *videoConnection;
    
    for (AVCaptureConnection *connection in[self.videoDataOutput connections]) {
        for (AVCaptureInputPort *port in[connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
            }
        }
    }
    
    
    if ([videoConnection isVideoStabilizationSupported]) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
            videoConnection.enablesVideoStabilizationWhenAvailable = YES;
        }
        else {
            videoConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
    }
    
    AVCaptureDevice *device = [self activeCamera];
    
    // Use Smooth focus
    if( YES == [device lockForConfiguration:NULL] )
    {
        if([device respondsToSelector:@selector(setSmoothAutoFocusEnabled:)] && [device isSmoothAutoFocusSupported] )
        {
            [device setSmoothAutoFocusEnabled:YES];
        }
        AVCaptureFocusMode currentMode = [device focusMode];
        if( currentMode == AVCaptureFocusModeLocked )
        {
            currentMode = AVCaptureFocusModeAutoFocus;
        }
        if( [device isFocusModeSupported:currentMode] )
        {
            [device setFocusMode:currentMode];
        }
        [device unlockForConfiguration];
    }

	[self.captureSession commitConfiguration];

//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
	return YES;
}

- (void)startSession {
	if (![self.captureSession isRunning]) {
		dispatch_async([self globalQueue], ^{
		    [self.captureSession startRunning];
		});
	}
}

- (void)stopSession {
	if ([self.captureSession isRunning]) {
		dispatch_async([self globalQueue], ^{
		    [self.captureSession stopRunning];
		});
	}
}

- (void)deviceOrientationChanged:(id)sender {
	dispatch_sync([self globalQueue], ^{
	    if (self.isWriting) {
	        return;
		}
	    [self updateOrientation];
	});
}

- (void)updateOrientation {
	AVCaptureConnection *videoConnection;

	for (AVCaptureConnection *connection in[self.videoDataOutput connections]) {
		for (AVCaptureInputPort *port in[connection inputPorts]) {
			if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
				videoConnection = connection;
			}
		}
	}


	if ([videoConnection isVideoOrientationSupported]) {
		videoConnection.videoOrientation = self.currentVideoOrientation;
	}

	if ([videoConnection isVideoStabilizationSupported]) {
		if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
			videoConnection.enablesVideoStabilizationWhenAvailable = YES;
		}
		else {
			videoConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
		}
	}

	AVCaptureDevice *device = [self activeCamera];

    // Use Smooth focus
    NSError *error;
    if( YES == [device lockForConfiguration:NULL] )
    {
        if( [device isSmoothAutoFocusSupported] )
        {
            [device setSmoothAutoFocusEnabled:YES];
        }
        AVCaptureFocusMode currentMode = [device focusMode];
        if( currentMode == AVCaptureFocusModeLocked )
        {
            currentMode = AVCaptureFocusModeAutoFocus;
        }
        if( [device isFocusModeSupported:currentMode] )
        {
            [device setFocusMode:currentMode];
        }
        [device unlockForConfiguration];
    }else {
        [self.delegate deviceConfigurationFailedWithError:error];
    }

}

- (dispatch_queue_t)globalQueue {
	return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
}

#pragma mark - Device Configuration

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
	NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
	for (AVCaptureDevice *device in devices) {
		if (device.position == position) {
			return device;
		}
	}
	return nil;
}

- (AVCaptureDevice *)activeCamera {
	return self.activeVideoInput.device;
}

- (AVCaptureDevice *)inactiveCamera {
	AVCaptureDevice *device = nil;
	if (self.cameraCount > 1) {
		if ([self activeCamera].position == AVCaptureDevicePositionBack) {
			device = [self cameraWithPosition:AVCaptureDevicePositionFront];
		}
		else {
			device = [self cameraWithPosition:AVCaptureDevicePositionBack];
		}
	}
	return device;
}

- (BOOL)canSwitchCameras {
	return self.cameraCount > 1;
}

- (NSUInteger)cameraCount {
	return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
}

- (BOOL)switchCameras {
	if (![self canSwitchCameras]) {
		return NO;
	}
    
	NSError *error;
	AVCaptureDevice *videoDevice = [self inactiveCamera];

	AVCaptureDeviceInput *videoInput =
	    [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];

	if (videoInput) {
		[self.captureSession beginConfiguration];

		[self.captureSession removeInput:self.activeVideoInput];

		if ([self.captureSession canAddInput:videoInput]) {
			[self.captureSession addInput:videoInput];
			self.activeVideoInput = videoInput;
		}
		else {
			[self.captureSession addInput:self.activeVideoInput];
		}

		[self.captureSession commitConfiguration];
	}
	else {
		[self.delegate deviceConfigurationFailedWithError:error];
		return NO;
	}
    
    
    self.faceObjects = nil;
    
	return YES;
}

#pragma mark - Flash and Torch Modes

- (BOOL)cameraHasFlash {
	return [[self activeCamera] hasFlash];
}

- (AVCaptureFlashMode)flashMode {
	return [[self activeCamera] flashMode];
}

- (void)setFlashMode:(AVCaptureFlashMode)flashMode {
	AVCaptureDevice *device = [self activeCamera];

	if (device.flashMode != flashMode &&
	    [device isFlashModeSupported:flashMode]) {
		NSError *error;
		if ([device lockForConfiguration:&error]) {
			device.flashMode = flashMode;
			[device unlockForConfiguration];
		}
		else {
			[self.delegate deviceConfigurationFailedWithError:error];
		}
	}
}

- (BOOL)cameraHasTorch {
	return [[self activeCamera] hasTorch];
}

- (AVCaptureTorchMode)torchMode {
	return [[self activeCamera] torchMode];
}

- (void)setTorchMode:(AVCaptureTorchMode)torchMode {
	AVCaptureDevice *device = [self activeCamera];

	if (device.torchMode != torchMode &&
	    [device isTorchModeSupported:torchMode]) {
		NSError *error;
		if ([device lockForConfiguration:&error]) {
			device.torchMode = torchMode;
			[device unlockForConfiguration];
		}
		else {
			[self.delegate deviceConfigurationFailedWithError:error];
		}
	}
}

#pragma mark - Focus Methods

- (BOOL)cameraSupportsTapToFocus {
	return [[self activeCamera] isFocusPointOfInterestSupported];
}

- (void)focusAtPoint:(CGPoint)point {
	AVCaptureDevice *device = [self activeCamera];

	if (device.isFocusPointOfInterestSupported &&
	    [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
		NSError *error;
		if ([device lockForConfiguration:&error]) {
			device.focusPointOfInterest = point;
			device.focusMode = AVCaptureFocusModeAutoFocus;
			[device unlockForConfiguration];
		}
		else {
			[self.delegate deviceConfigurationFailedWithError:error];
		}
	}
}

#pragma mark - Exposure Methods

- (BOOL)cameraSupportsTapToExpose {
	return [[self activeCamera] isExposurePointOfInterestSupported];
}

// Define KVO context pointer for observing 'adjustingExposure" device property.
static const NSString *THCameraAdjustingExposureContext;

- (void)exposeAtPoint:(CGPoint)point {
	AVCaptureDevice *device = [self activeCamera];

	AVCaptureExposureMode exposureMode =
	    AVCaptureExposureModeContinuousAutoExposure;

	if (device.isExposurePointOfInterestSupported &&
	    [device isExposureModeSupported:exposureMode]) {
		NSError *error;
		if ([device lockForConfiguration:&error]) {
			device.exposurePointOfInterest = point;
			device.exposureMode = exposureMode;

			if ([device isExposureModeSupported:AVCaptureExposureModeLocked]) {
				[device addObserver:self
				         forKeyPath:@"adjustingExposure"
				            options:NSKeyValueObservingOptionNew
				            context:&THCameraAdjustingExposureContext];
			}

			[device unlockForConfiguration];
		}
		else {
			[self.delegate deviceConfigurationFailedWithError:error];
		}
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
	if (context == &THCameraAdjustingExposureContext) {
		AVCaptureDevice *device = (AVCaptureDevice *)object;

		if (!device.isAdjustingExposure &&
		    [device isExposureModeSupported:AVCaptureExposureModeLocked]) {
			[object removeObserver:self
			            forKeyPath:@"adjustingExposure"
			               context:&THCameraAdjustingExposureContext];

			dispatch_async(dispatch_get_main_queue(), ^{
			    NSError *error;
			    if ([device lockForConfiguration:&error]) {
			        device.exposureMode = AVCaptureExposureModeLocked;
			        [device unlockForConfiguration];
				}
			    else {
			        [self.delegate deviceConfigurationFailedWithError:error];
				}
			});
		}
	}
	else {
		[super observeValueForKeyPath:keyPath
		                     ofObject:object
		                       change:change
		                      context:context];
	}
}

- (void)resetFocusAndExposureModes {
	AVCaptureDevice *device = [self activeCamera];

	AVCaptureExposureMode exposureMode =
	    AVCaptureExposureModeContinuousAutoExposure;

	AVCaptureFocusMode focusMode = AVCaptureFocusModeContinuousAutoFocus;

	BOOL canResetFocus = [device isFocusPointOfInterestSupported] &&
	    [device isFocusModeSupported:focusMode];

	BOOL canResetExposure = [device isExposurePointOfInterestSupported] &&
	    [device isExposureModeSupported:exposureMode];

	CGPoint centerPoint = CGPointMake(0.5f, 0.5f);

	NSError *error;
	if ([device lockForConfiguration:&error]) {
		if (canResetFocus) {
			device.focusMode = focusMode;
			device.focusPointOfInterest = centerPoint;
		}

		if (canResetExposure) {
			device.exposureMode = exposureMode;
			device.exposurePointOfInterest = centerPoint;
		}

		[device unlockForConfiguration];
	}
	else {
		[self.delegate deviceConfigurationFailedWithError:error];
	}
}

#pragma mark - Image Capture Methods



- (void)captureStillImage {
	AVCaptureConnection *connection =
	    [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];

	if (connection.isVideoOrientationSupported) {
		connection.videoOrientation = [self currentVideoOrientation];
	}

	id handler = ^(CMSampleBufferRef sampleBuffer, NSError *error) {
		if (sampleBuffer != NULL) {
			NSData *imageData =
			    [AVCaptureStillImageOutput
			 jpegStillImageNSDataRepresentation:sampleBuffer];

			UIImage *image = [[UIImage alloc] initWithData:imageData];
			[self writeImageToAssetsLibrary:image];
		}
		else {
			NSLog(@"NULL sampleBuffer: %@", [error localizedDescription]);
		}
	};
	// Capture still image
	[self.imageOutput captureStillImageAsynchronouslyFromConnection:connection
	                                              completionHandler:handler];
}

- (void)writeImageToAssetsLibrary:(UIImage *)image {
	ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];

	[library writeImageToSavedPhotosAlbum:image.CGImage
	                          orientation:(NSInteger)image.imageOrientation
	                      completionBlock: ^(NSURL *assetURL, NSError *error) {
	    if (!error) {
	        [self postThumbnailNotifification:image];
		}
	    else {
	        id message = [error localizedDescription];
	        NSLog(@"Error: %@", message);
		}
	}];
}

- (void)postThumbnailNotifification:(UIImage *)image {
	dispatch_async(dispatch_get_main_queue(), ^{
	    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	    [nc postNotificationName:KSHThumbnailCreatedNotification object:image];
	});
}

#pragma mark - Video Capture Methods

- (BOOL)isRecording {
	return self.isWriting;
}

- (void)startRecording {
	dispatch_async([self globalQueue], ^{
	    if (![self isRecording]) {
	        self.videoSettings = [[self.videoDataOutput recommendedVideoSettingsForAssetWriterWithOutputFileType:AVFileTypeMPEG4] mutableCopy];
            
	        self.audioSettings = [self.audioDataOutput recommendedAudioSettingsForAssetWriterWithOutputFileType:AVFileTypeMPEG4];

	        self.outputURL = [self uniqueURL];
	        self.startTime = kCMTimeZero;
	        NSError *error = nil;

	        NSString *fileType = AVFileTypeMPEG4;
	        self.assetWriter =
	            [AVAssetWriter assetWriterWithURL:self.outputURL
	                                     fileType:fileType
	                                        error:&error];
	        if (!self.assetWriter || error) {
	            NSString *formatString = @"Could not create AVAssetWriter: %@";
	            NSLog(@"%@", [NSString stringWithFormat:formatString, error]);

	            return;
			}

	        self.assetWriterVideoInput =
	            [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeVideo
	                                           outputSettings:self.videoSettings];

	        self.assetWriterVideoInput.expectsMediaDataInRealTime = YES;
            
            UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
            self.assetWriterVideoInput.transform = KSHTransformForDeviceOrientation(orientation);
            
            NSDictionary *attributes = @{(id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA),
                                         (id)kCVPixelBufferWidthKey : self.videoSettings[AVVideoWidthKey],
                                         (id)kCVPixelBufferHeightKey : self.videoSettings[AVVideoHeightKey],
                                         (id)kCVPixelFormatOpenGLESCompatibility : (id)kCFBooleanTrue
                                         };
            self.assetWriterInputPixelBufferAdaptor = [[AVAssetWriterInputPixelBufferAdaptor alloc]
             initWithAssetWriterInput:self.assetWriterVideoInput
             sourcePixelBufferAttributes:attributes];

	        if ([self.assetWriter canAddInput:self.assetWriterVideoInput]) {
	            [self.assetWriter addInput:self.assetWriterVideoInput];
			}
	        else {
	            NSLog(@"Unable to add video input.");

	            return;
			}

	        self.assetWriterAudioInput =
	            [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeAudio
	                                           outputSettings:self.audioSettings];

	        self.assetWriterAudioInput.expectsMediaDataInRealTime = YES;

	        if ([self.assetWriter canAddInput:self.assetWriterAudioInput]) {
	            [self.assetWriter addInput:self.assetWriterAudioInput];
			}
	        else {
	            NSLog(@"Unable to add audio input.");
			}

	        self.isWriting = YES;
	        self.firstSample = YES;
		}
	});
}

- (NSURL *)uniqueURL {
	NSString *fileName = [[NSProcessInfo processInfo] globallyUniqueString];

	NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];

	NSString *movieDirectory = [NSString stringWithFormat:@"%@/Videos", documentsPath];

	BOOL isDirectory;

	NSFileManager *fileManager = [NSFileManager defaultManager];

	if (![fileManager fileExistsAtPath:movieDirectory isDirectory:&isDirectory]) {
		[fileManager createDirectoryAtPath:movieDirectory withIntermediateDirectories:YES attributes:nil error:nil];
	}

	NSString *filePath = nil;
	do {
		filePath = [NSString stringWithFormat:@"%@/%@.mp4", movieDirectory, fileName];
	}
	while ([[NSFileManager defaultManager] fileExistsAtPath:filePath]);

	NSURL *fileURL = [NSURL fileURLWithPath:filePath];

	return fileURL;
}

- (void)stopRecording {
	dispatch_async([self globalQueue], ^{
	    self.isWriting = NO;
	    self.startTime = kCMTimeZero;
	    self.recordedDuration = 0;
	    [self.assetWriter finishWritingWithCompletionHandler: ^{
	        if (self.assetWriter.status == AVAssetWriterStatusCompleted) {
	            dispatch_async(dispatch_get_main_queue(), ^{
	                NSURL *fileURL = [self.assetWriter outputURL];
	                [self writeVideoToAssetsLibrary:[fileURL copy]];
                    NSLog(@"----finish recoding");
				});
	            self.outputURL = nil;
			}
	        else {
	            NSLog(@"Failed to write movie: %@", self.assetWriter.error);
			}
		}];
	});
}

#pragma mark - AVCaptureFileOutputRecordingDelegate

- (void)                  captureOutput:(AVCaptureFileOutput *)captureOutput
    didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL
                        fromConnections:(NSArray *)connections
                                  error:(NSError *)error {
	if (error) {
		[self.delegate mediaCaptureFailedWithError:error];
	}
	else {
		[self writeVideoToAssetsLibrary:[self.outputURL copy]];
	}
	self.outputURL = nil;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CIImage *sourceImage;
//    CIImage *filteredImage;
    
    __block CVPixelBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    if ([captureOutput isEqual:self.videoDataOutput]) {

        
//        sourceImage = [CIImage imageWithCVPixelBuffer:imageBuffer
//                                              options:nil];
//        if(self.bShowCutImg == NO)
//        [self.imageTarget updateContentImage:sourceImage];

        if(bInProcessing == NO)
        {
            [self doRec:imageBuffer];
        }
    }
    
    
/*
	if ([captureOutput isEqual:self.videoDataOutput] && self.isWriting) {
		CMTime timestamp =
		    CMSampleBufferGetPresentationTimeStamp(sampleBuffer);

		if (self.firstSample) {
			if ([self.assetWriter startWriting]) {
				[self.assetWriter startSessionAtSourceTime:timestamp];
				self.startTime = timestamp;
			}
			else {
				NSLog(@"Failed to start writing.");
			}
			self.firstSample = NO;
		}
		if (self.assetWriterVideoInput.readyForMoreMediaData) {
            
            CVPixelBufferRef outputRenderBuffer = NULL;
            
            CVPixelBufferPoolRef pixelBufferPool =
            self.assetWriterInputPixelBufferAdaptor.pixelBufferPool;
            
            OSStatus err = CVPixelBufferPoolCreatePixelBuffer(NULL,             // 3
                                                              pixelBufferPool,
                                                              &outputRenderBuffer);
            if (err) {
                NSLog(@"Unable to obtain a pixel buffer from the pool.");
                return;
            }
            
            
            
			self.recordedDuration = CMTimeGetSeconds(CMTimeSubtract(timestamp, self.startTime));
            
            [self.ciContext render:filteredImage toCVPixelBuffer:outputRenderBuffer bounds:filteredImage.extent colorSpace:nil];
			
            if (![self.assetWriterInputPixelBufferAdaptor appendPixelBuffer:outputRenderBuffer withPresentationTime:timestamp]) {
				NSLog(@"Error appending pixel buffer.");
			}
            CVPixelBufferRelease(outputRenderBuffer);
		}
	}
	else if (!self.firstSample && [captureOutput isEqual:self.audioDataOutput] && self.isWriting) {
		if (self.assetWriterAudioInput.isReadyForMoreMediaData) {
			if (![self.assetWriterAudioInput appendSampleBuffer:sampleBuffer]) {
				NSLog(@"Error appending audio sample buffer.");
			}
		}
	}
    */
    
}

- (CIImage*)makeFaceWithCIImage:(CIImage *)inputImage
{
    [self.filter setValue:inputImage forKey:kCIInputImageKey];
    [self.filter setValue:@(MAX(inputImage.extent.size.width, inputImage.extent.size.height) / 60) forKey:kCIInputScaleKey];
    CIImage *fullPixellatedImage = self.filter.outputImage;
    
    CIImage *maskImage;
    for (AVMetadataFaceObject *faceObject in self.faceObjects) {
        CGRect faceBounds = faceObject.bounds;
        CGFloat centerX = inputImage.extent.size.width * (faceBounds.origin.x + faceBounds.size.width/2);
        CGFloat centerY = inputImage.extent.size.height * (1 - faceBounds.origin.y - faceBounds.size.height /2);
        
        CGFloat radius = faceBounds.size.width * inputImage.extent.size.width/1.5;

        CIFilter *radialGradient = [CIFilter filterWithName:@"CIRadialGradient" keysAndValues:@"inputRadius0",@(radius),@"inputRadius1",@(radius+1),@"inputColor0",[CIColor colorWithRed:0 green:1 blue:0 alpha:1],@"inputColor1",[CIColor colorWithRed:0 green:0 blue:0 alpha:0],kCIInputCenterKey,[CIVector vectorWithX:centerX Y:centerY], nil];
        
        CIImage *radialGradientOutputImage = [radialGradient.outputImage imageByCroppingToRect:inputImage.extent];
        if (maskImage == nil) {
            maskImage = radialGradientOutputImage;
        }else{
            maskImage = [[CIFilter filterWithName:@"CISourceOverCompositing" keysAndValues:kCIInputImageKey,radialGradientOutputImage,kCIInputBackgroundImageKey,maskImage,nil] outputImage];
        }
    }
    
    CIFilter *blendFilter = [CIFilter filterWithName:@"CIBlendWithMask"];
    [blendFilter setValue:fullPixellatedImage forKey:kCIInputImageKey];
    [blendFilter setValue:inputImage forKey:kCIInputBackgroundImageKey];
    [blendFilter setValue:maskImage forKey:kCIInputMaskImageKey];
    
    return blendFilter.outputImage;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection {
    self.faceObjects = metadataObjects;
}

- (void)writeVideoToAssetsLibrary:(NSURL *)videoURL {
	ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];

	if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:videoURL]) {
		ALAssetsLibraryWriteVideoCompletionBlock completionBlock;

		completionBlock = ^(NSURL *assetURL, NSError *error) {
			if (error) {
				[self.delegate assetLibraryWriteFailedWithError:error];
			}
			else {
				[self generateThumbnailForVideoAtURL:videoURL];
			}
		};

		[library writeVideoAtPathToSavedPhotosAlbum:videoURL
		                            completionBlock:completionBlock];
	}
}

- (void)generateThumbnailForVideoAtURL:(NSURL *)videoURL {
	dispatch_async([self globalQueue], ^{
	    AVAsset *asset = [AVAsset assetWithURL:videoURL];

	    AVAssetImageGenerator *imageGenerator =
	        [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
	    imageGenerator.maximumSize = CGSizeMake(100.0f, 0.0f);
	    imageGenerator.appliesPreferredTrackTransform = YES;

	    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:kCMTimeZero
	                                                 actualTime:NULL
	                                                      error:nil];
	    UIImage *image = [UIImage imageWithCGImage:imageRef];
	    CGImageRelease(imageRef);

	    dispatch_async(dispatch_get_main_queue(), ^{
	        [self postThumbnailNotifification:image];
		});
	});
}

#pragma mark - Recoding Destination URL

- (AVCaptureVideoOrientation)currentVideoOrientation {
	AVCaptureVideoOrientation videoOrientation;

	UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];

	switch (deviceOrientation) {
		case UIDeviceOrientationLandscapeLeft:
			videoOrientation = AVCaptureVideoOrientationLandscapeRight;
			break;

		case UIDeviceOrientationLandscapeRight:
			videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
			break;

		case UIDeviceOrientationPortrait:
			videoOrientation = AVCaptureVideoOrientationPortrait;
			break;

		case UIDeviceOrientationPortraitUpsideDown:
			videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
			break;

		default:
			videoOrientation = AVCaptureVideoOrientationPortrait;
			break;
	}

	return videoOrientation;
}

CGAffineTransform KSHTransformForDeviceOrientation(UIDeviceOrientation orientation) {
    CGAffineTransform result;
    
    switch (orientation) {
            
        case UIDeviceOrientationLandscapeRight:
            result = CGAffineTransformMakeRotation(M_PI);
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            result = CGAffineTransformMakeRotation((M_PI_2 * 3));
            break;
            
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
            result = CGAffineTransformMakeRotation(M_PI_2);
            break;
            
        default: // Default orientation of landscape left
            result = CGAffineTransformIdentity;
            break;
    }
    
    return result;
}

#pragma mark do reco

CGRect getGuideFrame( CGRect rect)
{
    float previewWidth = rect.size.height;
    float previewHeight = rect.size.width;
    
    float cardh, cardw;
    float lft, top;
    
    cardw = previewWidth*70/100;
//    if(cardw < 720) cardw = 720;
    if(previewWidth < cardw)
        cardw = previewWidth;
    
    cardh = (int)(cardw / 0.63084f);
    
    lft = (previewWidth-cardw)/2;
    top = (previewHeight-cardh)/2;
    
    CGRect r = CGRectMake(top+rect.origin.x, lft+rect.origin.y, cardh, cardw);
    return r;
}


CGRect combinRect(CGRect A, CGRect B)
{
    CGFloat t,b,l,r;
    l = fminf(A.origin.x, B.origin.x);
    r = fmaxf(A.size.width+A.origin.x, B.size.width+B.origin.x);
    t = fminf(A.origin.y, B.origin.y);
    b = fmaxf(A.size.height+A.origin.y, B.size.height+B.origin.y);
    
    return CGRectMake(l, t, r-l, b-t);
}

CGRect getCorpCardRect( int width, int height, CGRect guideRect, int charCount)
{
    subRect = rects[0];
    
    int i;
    int nAvgW = 0;
    int nAvgH = 0;
    int nCount = 0;
//    Rect rect = new Rect(cardInfo.rects[0]);
    nAvgW  = rects[0].size.width;
    nAvgH  = rects[0].size.height;
    nCount = 1;
    //所有非空格的字符的矩形框合并
    for(i = 1; i < charCount; ++i){
        
//        rect.union(cardInfo.rects[i]);
        subRect = combinRect(subRect, rects[i]);
        if(numbers[i] != ' '){
            nAvgW += rects[i].size.width;
            nAvgH += rects[i].size.height;
            nCount ++;
        }
    }
    //统计得到的平均宽度和高度
    nAvgW /= nCount;
    nAvgH /= nCount;
    
    //releative to the big image（相对于大图）
    subRect.origin.x = subRect.origin.x + guideRect.origin.x;
    subRect.origin.y = subRect.origin.y + guideRect.origin.y;
//    rect.offset(guideRect.left, guideRect.top);
    //做一个扩展
    subRect.origin.y -= nAvgH;  if(subRect.origin.y < 0) subRect.origin.y = 0;
    subRect.size.height += nAvgH * 2; if(subRect.size.height+subRect.origin.y  >= height) subRect.size.height = height-subRect.origin.y-1;
    subRect.origin.x -= nAvgW; if(subRect.origin.x < 0) subRect.origin.x = 0;
    subRect.size.width += nAvgW * 2; if(subRect.size.width+subRect.origin.x >= width) subRect.size.width = width-subRect.origin.x-1;
    return subRect;
}

int docode(unsigned char *pbBuf, int tLen)
{
    int hic, lwc;
    int i, j, code;
    int x, y, w, h;
    int charCount = 0;
    
    nType = 0;
    nRate = 0;
    nCharNum = 0;
    szBankName[0]=0;
    numbers[0] = 0;
    
    //字符解析，包含空格
    i = 0;
    //nType
    hic = pbBuf[i++]; lwc = pbBuf[i++]; code = (hic<<8)+lwc;
    nType = code;
    //nRate
    hic = pbBuf[i++]; lwc = pbBuf[i++]; code = (hic<<8)+lwc;
    nRate = code;
    
    //bank name, GBK CharSet;
    for(j = 0; j < 64; ++j) { szBankName[j] = pbBuf[i++]; }
    
    //nCharNum
    hic = pbBuf[i++]; lwc = pbBuf[i++]; code = (hic<<8)+lwc;
    nCharNum = code;
    
    //char code and its rect
    while(i < tLen-9){
        //字符的编码unsigned short
        hic = pbBuf[i++]; lwc = pbBuf[i++]; x = (hic<<8)+lwc;
        numbers[charCount] = (char)x;
        //字符的矩形框lft, top, w, h
        hic = pbBuf[i++]; lwc = pbBuf[i++]; x = (hic<<8)+lwc;
        hic = pbBuf[i++]; lwc = pbBuf[i++]; y = (hic<<8)+lwc;
        hic = pbBuf[i++]; lwc = pbBuf[i++]; w = (hic<<8)+lwc;
        hic = pbBuf[i++]; lwc = pbBuf[i++]; h = (hic<<8)+lwc;
        rects[charCount] = CGRectMake(x, y, w, h);
        charCount++;
    }
    numbers[charCount] = 0;
    
    if(charCount < 10 || charCount > 24 || nCharNum != charCount){
        charCount = 0;
    }
    return charCount;
}

-(UIImage*)getSubImage:(CGRect)rect inImage:(UIImage*)img

{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(img.CGImage, rect);
    
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawImage(context, smallBounds, subImageRef);
    
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CFRelease(subImageRef);
    
    UIGraphicsEndImageContext();
    
    return smallImage;
    
}

-(UIImage*) getImageStream:(CVImageBufferRef)imageBuffer
{
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:imageBuffer];
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
                             createCGImage:ciImage
                             fromRect:CGRectMake(0, 0,
                                                 CVPixelBufferGetWidth(imageBuffer),
                                                 CVPixelBufferGetHeight(imageBuffer))];
    
    UIImage *image = [[UIImage alloc] initWithCGImage:videoImage];
    
    CGImageRelease(videoImage);
    return image;
}



-(void)doRec:(CVImageBufferRef)imageBuffer
{
    @synchronized(self)
    {
        CVBufferRetain(imageBuffer);
        bInProcessing = YES;
        if(bHasResult == YES)
        {
            return;
        }
        
        if(CVPixelBufferLockBaseAddress(imageBuffer, 0) == kCVReturnSuccess)
        {
            size_t width= CVPixelBufferGetWidth(imageBuffer);
            size_t height = CVPixelBufferGetHeight(imageBuffer);
            
            CVPlanarPixelBufferInfo_YCbCrBiPlanar *planar = CVPixelBufferGetBaseAddress(imageBuffer);
            size_t offset = NSSwapBigIntToHost(planar->componentInfoY.offset);
            size_t rowBytes = NSSwapBigIntToHost(planar->componentInfoY.rowBytes);
            unsigned char* baseAddress = (unsigned char *)CVPixelBufferGetBaseAddress(imageBuffer);
            unsigned char* pixelAddress = baseAddress + offset;
            
            size_t cbCrOffset = NSSwapBigIntToHost(planar->componentInfoCbCr.offset);
            size_t cbCrPitch = NSSwapBigIntToHost(planar->componentInfoCbCr.rowBytes);
            uint8_t *cbCrBuffer = baseAddress + cbCrOffset;
            

            CGRect effectRect = [self.recDelegate getEffectImageRect:CGSizeMake(width, height)];
            CGRect rect = getGuideFrame(effectRect);
#if 1
            
            unsigned char result [512];
            int nResultLen = BankCardNV12(result, 512, pixelAddress, cbCrBuffer, width, height, rect.origin.x, rect.origin.y, rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
            
            if(self.bShowCutImg)
            {
                UIImage *img = [self getImageStream:imageBuffer];
                UIImage *subImg = [self getSubImage:rect inImage:img];
//                UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
                
                CIImage *ciImg = [[CIImage alloc] initWithCGImage:subImg.CGImage options:nil];//[CIImage imageWithCGImage:subImg.CGImage];
                [self.imageTarget updateContentImage2:ciImg];
            }
            
            if(nResultLen > 0)
            {
                int nCharCount = docode(result, nResultLen);
                if(nCharCount > 0)
                {
                    
                    
                    getCorpCardRect(width, height, rect, nCharCount);
                    //                CGRect getCorpCardRect( int width, int height, CGRect guideRect, int charCount)
                    
                    //                subRect.origin.x = subRect.origin.x + rect.origin.x;
                    //                subRect.origin.y = subRect.origin.y + rect.origin.y;
                    bHasResult = YES;
                    //                NSLog(@"%@",str);
                    
                    UIImage *img = [self getImageStream:imageBuffer];
                    __block UIImage *subImg = [self getSubImage:subRect inImage:img];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //                    NSString *strNum = [NSString stringWithCString:numbers encoding:NSASCIIStringEncoding];
                        //                    NSString *strerror = [NSString stringWithFormat:@"%d %@", nResultLen, strNum];//[NSString stringWithUTF8String:result];//[NSString stringWithFormat:@"%s", result];
                        //                    [self.recDelegate showRecError:strerror];
                        //goto result
                        //                    [self stopSession];
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                        NSString *str = [NSString stringWithCString:numbers encoding:NSASCIIStringEncoding];
                        [self.recDelegate didEndRecNumber:str image:subImg];
                    });
                }
            }
#endif
            
            CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
            bInProcessing = NO;
        }
        CVBufferRelease(imageBuffer);
    }
}
@end
