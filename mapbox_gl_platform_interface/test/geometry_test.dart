import 'package:flutter/material.dart';
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart' hide Visibility;
import 'package:mapbox_gl_platform_interface/mapbox_gl_platform_interface.dart' as mb;
import 'package:test/test.dart';

final data = [
    {
        "id": 0,
        "type": "Feature",
        "properties": {
            "Longitude": 5.771169662475586,
            "Latitude": 59.094473963626434,
            "PointId": "09534e9967bd606c650f297f52ee1266d27f2e3ee3ba404033de1b41d8625488",
            "Reward": 16,
            "PointType": 1
        },
        "geometry": {
            "type": "Point",
            "coordinates": [
                5.771169662475586,
                59.09449049538577
            ]
        }
    },
    {
        "properties": {
            "Longitude": 5.846142768859863,
            "Latitude": 59.07239695795349,
            "PointId": "7f36743c80cd6ef497555faa1663c020a857fdfab84cf946d8468402c420af98",
            "Reward": 16,
            "PointType": 1
        },
        "type": "Feature",
        "id": 0,
        "geometry": {
            "type": "Point",
            "coordinates": [
                5.846142768859863,
                59.072396957953515
            ]
        }
    },
    {
        "type": "Feature",
        "id": 0,
        "geometry": {
            "type": "Point",
            "coordinates": [
                5.846142768859863,
                58.98191231759918
            ]
        },
        "properties": {
            "Longitude": 5.846142768859863,
            "Latitude": 58.98191231759916,
            "PointId": "76ab29a310655a0e0387d98dac036478650b2f9850088b45d7ad1cdcebfc8822",
            "Reward": 16,
            "PointType": 1
        }
    }
];



void main() {

  test('Feature instanciated from the same map should equal each other', () {

    final Feature feature1 = Feature.fromMap(data[0]);
    final Feature feature2 = Feature.fromMap(data[0]);


    expect(feature1, equals(feature2));

  });


}