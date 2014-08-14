#!/usr/bin/env objc-run

@import Foundation;


NSArray* fieldsFromCSVLine(NSString* inLine)
{
	NSMutableArray	*scannedFields = [NSMutableArray array];
	NSScanner		*scanner = [NSScanner scannerWithString:inLine];
	NSString		*field;
	
	while (YES ==[scanner scanUpToString:@"," intoString:&field])
	{
		if (field)
		{
			[scannedFields addObject:field];
		}
		[scanner scanString:@"," intoString:nil]; // consume , character
		if ([scanner scanString:@"\"" intoString:nil]) // if " character follows
		{
			NSString *descriptionField;
			
			[scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\""] intoString:&descriptionField];
			[scannedFields addObject:descriptionField];
			[scanner scanString:@"\"" intoString:nil]; // consume terminating " character
			[scanner scanString:@"," intoString:nil]; // scan next comma, too
		}
	}
	
	return scannedFields;
}

int main(int argc, char *argv[]) {
	@autoreleasepool {
		NSString 		*filePath = [[[NSProcessInfo processInfo] arguments] objectAtIndex:1];
		NSError  		*error;
		NSMutableString *xml = [NSMutableString stringWithString:@"<?xml version=\"1.0\"?>\n"];
		
		if (nil == filePath)
		{
			NSLog (@"usage: ./StripeCSV2XML.m <filename.csv>");
			return 1;
		}
		NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
		if (nil == fileContents)
		{
			NSLog (@"error while reading file %@", error);
		}
		NSArray 		*lines = [fileContents componentsSeparatedByString:@"\n"];
		NSString 		*header = [lines firstObject];
		NSMutableArray 	*columnTitles = [NSMutableArray array];
		
		for (NSString *columnTitle in [header componentsSeparatedByString:@","])
		{
			[columnTitles addObject:[columnTitle stringByReplacingOccurrencesOfString:@" " withString:@"-"]];
		}
		
		[xml appendString:@"<transactions>\n"];
		{
			for (NSInteger i = 1; i < lines.count;i++)
			{
				[xml appendString:@"<transaction>\n"];
				{
					NSString *line = lines[i];
					NSArray *fields = fieldsFromCSVLine(line);
					
					for (NSInteger fieldIndex = 0; fieldIndex < fields.count; fieldIndex++)
					{
						NSString *fieldValue = fields[fieldIndex];
						NSString *columnTitle = columnTitles[fieldIndex];
						
						[xml appendFormat:@"<%@>", columnTitle];
						{
							[xml appendString:fieldValue];
						}
						[xml appendFormat:@"</%@>\n", columnTitle];
					}
				}
				[xml appendString:@"</transaction>\n"];
			}
		}
		[xml appendString:@"</transactions>\n"];
		
		[(NSFileHandle*)[NSFileHandle fileHandleWithStandardOutput] writeData: [xml dataUsingEncoding: NSUTF8StringEncoding]];
	}
}
