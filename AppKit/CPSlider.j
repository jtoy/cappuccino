/*
 * CPSlider.j
 * AppKit
 *
 * Created by Francisco Tolmasky.
 * Copyright 2008, 280 North, Inc.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

import "CPControl.j"

var CPSliderHorizontalKnobImage         = nil
    CPSliderHorizontalBarLeftImage      = nil,
    CPSliderHorizontalBarRightImage     = nil,
    CPSliderHorizontalBarCenterImage    = nil;

@implementation CPSlider : CPControl
{
    double      _value;
    double      _minValue;
    double      _maxValue;
    double      _altIncrementValue;
    
    CPView      _bar;
    CPView      _knob;

    BOOL        _isVertical;
    CPImageView _standardKnob;
    CPView      _standardVerticalBar;
    CPView      _standardHorizontalBar;
}

+ (void)initialize
{
    if (self != [CPSlider class])
        return;

    var bundle = [CPBundle bundleForClass:self];
    
    CPSliderKnobImage = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPSlider/CPSliderKnobRegular.png"] size:CPSizeMake(11.0, 11.0)],
    CPSliderKnobPushedImage = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPSlider/CPSliderKnobRegularPushed.png"] size:CPSizeMake(11.0, 11.0)],
    CPSliderHorizontalBarLeftImage = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPSlider/CPSliderTrackHorizontalLeft.png"] size:CPSizeMake(2.0, 4.0)],
    CPSliderHorizontalBarRightImage = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPSlider/CPSliderTrackHorizontalRight.png"] size:CPSizeMake(2.0, 4.0)],
    CPSliderHorizontalBarCenterImage = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"CPSlider/CPSliderTrackHorizontalCenter.png"] size:CPSizeMake(1.0, 4.0)];
}

- (id)initWithFrame:(CPRect)aFrame
{
    self = [super initWithFrame:aFrame];
    
    if (self)
    {
        _value = 50.0;
        _minValue = 0.0;
        _maxValue = 100.0;
    
        _bar = [self bar];
        _knob = [self knob];
        _knobSize = [[self knobImage] size];
        _isVertical = [self isVertical];
        
        [_knob setFrameOrigin:[self knobPosition]];
        
        [self addSubview:_bar];
        [self addSubview:_knob];
    }
    
    return self;
}
    
- (void)setFrameSize:(CPSize)aSize
{
    if(aSize.height > 21.0)
        aSize.height = 21.0;
    
    if (_isVertical != [self isVertical])
    {
        _isVertical = [self isVertical];
        
        var bar = [self bar],
            knob = [self knob];
        
        if (_bar != bar)
            [self replaceSubview:_bar = bar withView:_bar];
        
        if (_knob != knob)
        {
            [self replaceSubview:knob withView:_knob];
            
            _knob = knob;
            [_knob setFrameOrigin:[self knobPosition]];
        }
    }
    
    [super setFrameSize:aSize];
    
    [_knob setFrameOrigin:[self knobPosition]];
}
    
- (double)altIncrementValue
{
    return _altIncrementValue;
}
    
- (float)knobThickness
{
    return CPRectGetWidth([_knob frame]);
}

- (CPImage)leftTrackImage
{
    return CPSliderHorizontalBarLeftImage;
}

- (CPImage)rightTrackImage
{
    return CPSliderHorizontalBarRightImage;
}

- (CPImage)centerTrackImage
{
    return CPSliderHorizontalBarCenterImage
}

- (CPImage)knobImage
{
    return CPSliderKnobImage;
}

- (CPImage)pushedKnobImage
{
    return CPSliderKnobPushedImage;
}

- (CPView)knob
{
    if (!_standardKnob)
    {
        var knobImage = [self knobImage],
            knobSize = [knobImage size];
        
        _standardKnob = [[CPImageView alloc] initWithFrame:CPRectMake(0.0, 0.0, knobSize.width, knobSize.height)];
        
        [_standardKnob setImage:knobImage];
    }
    
    return _standardKnob;
}

- (CPView)bar
{
    // FIXME: veritcal.
    if ([self isVertical])
        return nil;
    else
    {
        if (!_standardHorizontalBar)
        {
            var frame = [self frame],
                barFrame = CPRectMake(0.0, 0.0, CPRectGetWidth(frame), 4.0);
                
            _standardHorizontalBar = [[CPView alloc] initWithFrame:barFrame];
            
            [_standardHorizontalBar setBackgroundColor:[CPColor colorWithPatternImage:[[CPThreePartImage alloc] initWithImageSlices:
                [[self leftTrackImage], [self centerTrackImage], [self rightTrackImage]] isVertical:NO]]];

            [_standardHorizontalBar setFrame:CPRectMake(0.0, (CPRectGetHeight(frame) - CPRectGetHeight(barFrame)) / 2.0, CPRectGetWidth(_isVertical ? barFrame : frame), CPRectGetHeight(_isVertical ? frame : barFrame))];
            [_standardHorizontalBar setAutoresizingMask:_isVertical ? CPViewHeightSizable : CPViewWidthSizable];
        }
        
        return _standardHorizontalBar;
    }
}

- (void)setAltIncrementValue:(double)anIncrementValue
{
    _altIncrementValue = anIncrementValue;
}

- (int)isVertical
{
    var frame = [self frame];
    
    if (CPRectGetWidth(frame) == CPRectGetHeight(frame))
        return -1;
    
    return CPRectGetWidth(frame) < CPRectGetHeight(frame);
}

- (double)maxValue
{
    return _maxValue;
}

- (double)minValue
{
    return _minValue;
}

- (void)setMaxValue:(double)aMaxValue
{
    _maxValue = aMaxValue;
}

- (void)setMinValue:(double)aMinValue
{
    _minValue = aMinValue;
}

- (void)setValue:(double)aValue
{
    _value = aValue;

    [_knob setFrameOrigin:[self knobPosition]];
}

- (double)value
{
    return _value;
}

- (CPPoint)knobPosition
{
    if ([self isVertical])
        return CPPointMake(0.0, 0.0);
    else
        return CPPointMake(
            ((_value - _minValue) / (_maxValue - _minValue)) * (CPRectGetWidth([self frame]) - CPRectGetWidth([_knob frame])), 
            (CPRectGetHeight([self frame]) - CPRectGetHeight([_knob frame])) / 2.0);
}

- (float)valueForKnobPosition:(CPPoint)aPoint
{
    if ([self isVertical])
        return 0.0;
    else
        return MAX(MIN((aPoint.x) * (_maxValue - _minValue) / ( CPRectGetWidth([self frame]) - CPRectGetWidth([_knob frame]) ) + _minValue, _maxValue), _minValue);
}

- (CPPoint)constrainKnobPosition:(CPPoint)aPoint
{
    //FIXME
    aPoint.x -= _knobSize.width / 2.0;
    return CPPointMake(MAX(MIN(CPRectGetWidth([self bounds]) - _knobSize.width, aPoint.x), 0.0), (CPRectGetHeight([self bounds]) - CPRectGetHeight([_knob frame])) / 2.0);
}

- (void)mouseUp:(CPEvent)anEvent
{
    [[self knob] setImage: [self knobImage]];

    if ([_target respondsToSelector:@selector(sliderDidFinish:)])
        [_target sliderDidFinish:self];
}

- (void)mouseDown:(CPEvent)anEvent
{
    [_knob setFrameOrigin:[self constrainKnobPosition:[self convertPoint:[anEvent locationInWindow] fromView:nil]]];

    _value = [self valueForKnobPosition:[_knob frame].origin];
    
    [[self knob] setImage: [self pushedKnobImage]];
    [self sendAction:_action to:_target];
}

- (void)mouseDragged:(CPEvent)anEvent
{
    [_knob setFrameOrigin:[self constrainKnobPosition:[self convertPoint:[anEvent locationInWindow] fromView:nil]]];
    
    _value = [self valueForKnobPosition:[_knob frame].origin];
    
    [self sendAction:_action to:_target];
}

@end

var CPSliderMinValueKey = @"CPSliderMinValueKey",
    CPSliderMaxValueKey = @"CPSliderMaxValueKey",
    CPSliderValueKey = @"CPSliderValueKey";

@implementation CPSlider (CPCoding)

- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super initWithCoder:aCoder];
    
    if (self)
    {
        _value = [aCoder decodeDoubleForKey:CPSliderValueKey];
        _minValue = [aCoder decodeDoubleForKey:CPSliderMinValueKey];
        _maxValue = [aCoder decodeDoubleForKey:CPSliderMaxValueKey];
    
        _bar = [self bar];
        _knob = [self knob];
        _knobSize = [[self knobImage] size];
        _isVertical = [self isVertical];
        
        [_knob setFrameOrigin:[self knobPosition]];
        
        [self addSubview:_bar];
        [self addSubview:_knob];
    }
    
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    var subviews = _subviews;
    
    _subviews = [];
         
    [super encodeWithCoder:aCoder];
    
    _subviews = subviews;
    
    [aCoder encodeDouble:_value forKey:CPSliderValueKey];
    [aCoder encodeDouble:_minValue forKey:CPSliderMinValueKey];
    [aCoder encodeDouble:_maxValue forKey:CPSliderMaxValueKey];
}

@end

var CPHUDSliderKnobImage = nil,
    CPHUDSliderHorizontalBarLeftImage = nil,
    CPHUDSliderHorizontalBarRightImage = nil,
    CPHUDSliderHorizontalBarCenterImage = nil;

@implementation CPHUDSlider : CPSlider
{
}

+ (void)initialize
{
    if (self != [CPHUDSlider class])
        return;

    var bundle = [CPBundle bundleForClass:self];

    CPHUDSliderKnobImage = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"HUDTheme/CPSliderHorizontalKnob.png"] size:CPSizeMake(12.0, 12.0)],
    CPHUDSliderHorizontalBarLeftImage = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"HUDTheme/CPSliderHorizontalBarLeft.png"] size:CPSizeMake(3.0, 4.0)],
    CPHUDSliderHorizontalBarRightImage = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"HUDTheme/CPSliderHorizontalBarRight.png"] size:CPSizeMake(3.0, 4.0)],
    CPHUDSliderHorizontalBarCenterImage = [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"HUDTheme/CPSliderHorizontalBarCenter.png"] size:CPSizeMake(1.0, 4.0)];
}

- (CPImage)leftTrackImage
{
    return CPHUDSliderHorizontalBarLeftImage;
}

- (CPImage)rightTrackImage
{
    return CPHUDSliderHorizontalBarRightImage;
}

- (CPImage)centerTrackImage
{
    return CPHUDSliderHorizontalBarCenterImage
}

- (CPImage)knobImage
{
    return CPHUDSliderKnobImage;
}

@end
