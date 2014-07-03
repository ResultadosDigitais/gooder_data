require 'spec_helper'

one_serie_json = <<-JS
{
    "xtab_data": {
        "columns": {
            "tree": {
                "index": {
                    "0": [
                        0
                    ]
                },
                "first": 0,
                "last": 0,
                "children": [
                    {
                        "index": {},
                        "first": 0,
                        "last": 0,
                        "children": [],
                        "type": "metric",
                        "id": "0"
                    }
                ],
                "type": "root",
                "id": null
            },
            "lookups": [
                {
                    "0": "Leads Gerados [Qtd]"
                }
            ]
        },
        "data": [
            [
                "136"
            ],
            [
                "100"
            ],
            [
                "13"
            ],
            [
                "71"
            ],
            [
                "36"
            ],
            [
                "29"
            ],
            [
                "27"
            ],
            [
                "62"
            ],
            [
                "45"
            ],
            [
                "77"
            ],
            [
                "83"
            ],
            [
                "124"
            ],
            [
                "135"
            ],
            [
                "195"
            ],
            [
                "365"
            ],
            [
                "467"
            ],
            [
                "590"
            ],
            [
                "773"
            ],
            [
                "915"
            ],
            [
                "1000"
            ],
            [
                "1346"
            ],
            [
                "1316"
            ],
            [
                "1570"
            ],
            [
                "1746"
            ],
            [
                "2407"
            ],
            [
                "2264"
            ],
            [
                "2508"
            ],
            [
                "2678"
            ],
            [
                "2540"
            ],
            [
                "3380"
            ],
            [
                "3080"
            ],
            [
                "3647"
            ],
            [
                "3621"
            ],
            [
                "4182"
            ],
            [
                "2959"
            ],
            [
                "4594"
            ],
            [
                "4149"
            ],
            [
                "11260"
            ],
            [
                "14100"
            ],
            [
                "6198"
            ],
            [
                "3688"
            ],
            [
                "7108"
            ],
            [
                "6620"
            ],
            [
                "7812"
            ],
            [
                "5026"
            ],
            [
                "9723"
            ],
            [
                "6595"
            ]
        ],
        "overall_size": {
            "columns": "1",
            "rows": "47"
        },
        "rows": {
            "tree": {
                "index": {
                    "24128": [
                        0
                    ],
                    "24129": [
                        1
                    ],
                    "24130": [
                        2
                    ],
                    "24131": [
                        3
                    ],
                    "24132": [
                        4
                    ],
                    "24133": [
                        5
                    ],
                    "24134": [
                        6
                    ],
                    "24135": [
                        7
                    ],
                    "24136": [
                        8
                    ],
                    "24137": [
                        9
                    ],
                    "24138": [
                        10
                    ],
                    "24139": [
                        11
                    ],
                    "24140": [
                        12
                    ],
                    "24141": [
                        13
                    ],
                    "24142": [
                        14
                    ],
                    "24143": [
                        15
                    ],
                    "24144": [
                        16
                    ],
                    "24145": [
                        17
                    ],
                    "24146": [
                        18
                    ],
                    "24147": [
                        19
                    ],
                    "24148": [
                        20
                    ],
                    "24149": [
                        21
                    ],
                    "24150": [
                        22
                    ],
                    "24151": [
                        23
                    ],
                    "24152": [
                        24
                    ],
                    "24153": [
                        25
                    ],
                    "24154": [
                        26
                    ],
                    "24155": [
                        27
                    ],
                    "24156": [
                        28
                    ],
                    "24157": [
                        29
                    ],
                    "24158": [
                        30
                    ],
                    "24159": [
                        31
                    ],
                    "24160": [
                        32
                    ],
                    "24161": [
                        33
                    ],
                    "24162": [
                        34
                    ],
                    "24163": [
                        35
                    ],
                    "24164": [
                        36
                    ],
                    "24165": [
                        37
                    ],
                    "24166": [
                        38
                    ],
                    "24167": [
                        39
                    ],
                    "24168": [
                        40
                    ],
                    "24169": [
                        41
                    ],
                    "24170": [
                        42
                    ],
                    "24171": [
                        43
                    ],
                    "24172": [
                        44
                    ],
                    "24173": [
                        45
                    ],
                    "24174": [
                        46
                    ]
                },
                "first": 0,
                "last": 46,
                "children": [
                    {
                        "index": {},
                        "first": 0,
                        "last": 0,
                        "children": [],
                        "type": "normal",
                        "id": "24128"
                    },
                    {
                        "index": {},
                        "first": 1,
                        "last": 1,
                        "children": [],
                        "type": "normal",
                        "id": "24129"
                    },
                    {
                        "index": {},
                        "first": 2,
                        "last": 2,
                        "children": [],
                        "type": "normal",
                        "id": "24130"
                    },
                    {
                        "index": {},
                        "first": 3,
                        "last": 3,
                        "children": [],
                        "type": "normal",
                        "id": "24131"
                    },
                    {
                        "index": {},
                        "first": 4,
                        "last": 4,
                        "children": [],
                        "type": "normal",
                        "id": "24132"
                    },
                    {
                        "index": {},
                        "first": 5,
                        "last": 5,
                        "children": [],
                        "type": "normal",
                        "id": "24133"
                    },
                    {
                        "index": {},
                        "first": 6,
                        "last": 6,
                        "children": [],
                        "type": "normal",
                        "id": "24134"
                    },
                    {
                        "index": {},
                        "first": 7,
                        "last": 7,
                        "children": [],
                        "type": "normal",
                        "id": "24135"
                    },
                    {
                        "index": {},
                        "first": 8,
                        "last": 8,
                        "children": [],
                        "type": "normal",
                        "id": "24136"
                    },
                    {
                        "index": {},
                        "first": 9,
                        "last": 9,
                        "children": [],
                        "type": "normal",
                        "id": "24137"
                    },
                    {
                        "index": {},
                        "first": 10,
                        "last": 10,
                        "children": [],
                        "type": "normal",
                        "id": "24138"
                    },
                    {
                        "index": {},
                        "first": 11,
                        "last": 11,
                        "children": [],
                        "type": "normal",
                        "id": "24139"
                    },
                    {
                        "index": {},
                        "first": 12,
                        "last": 12,
                        "children": [],
                        "type": "normal",
                        "id": "24140"
                    },
                    {
                        "index": {},
                        "first": 13,
                        "last": 13,
                        "children": [],
                        "type": "normal",
                        "id": "24141"
                    },
                    {
                        "index": {},
                        "first": 14,
                        "last": 14,
                        "children": [],
                        "type": "normal",
                        "id": "24142"
                    },
                    {
                        "index": {},
                        "first": 15,
                        "last": 15,
                        "children": [],
                        "type": "normal",
                        "id": "24143"
                    },
                    {
                        "index": {},
                        "first": 16,
                        "last": 16,
                        "children": [],
                        "type": "normal",
                        "id": "24144"
                    },
                    {
                        "index": {},
                        "first": 17,
                        "last": 17,
                        "children": [],
                        "type": "normal",
                        "id": "24145"
                    },
                    {
                        "index": {},
                        "first": 18,
                        "last": 18,
                        "children": [],
                        "type": "normal",
                        "id": "24146"
                    },
                    {
                        "index": {},
                        "first": 19,
                        "last": 19,
                        "children": [],
                        "type": "normal",
                        "id": "24147"
                    },
                    {
                        "index": {},
                        "first": 20,
                        "last": 20,
                        "children": [],
                        "type": "normal",
                        "id": "24148"
                    },
                    {
                        "index": {},
                        "first": 21,
                        "last": 21,
                        "children": [],
                        "type": "normal",
                        "id": "24149"
                    },
                    {
                        "index": {},
                        "first": 22,
                        "last": 22,
                        "children": [],
                        "type": "normal",
                        "id": "24150"
                    },
                    {
                        "index": {},
                        "first": 23,
                        "last": 23,
                        "children": [],
                        "type": "normal",
                        "id": "24151"
                    },
                    {
                        "index": {},
                        "first": 24,
                        "last": 24,
                        "children": [],
                        "type": "normal",
                        "id": "24152"
                    },
                    {
                        "index": {},
                        "first": 25,
                        "last": 25,
                        "children": [],
                        "type": "normal",
                        "id": "24153"
                    },
                    {
                        "index": {},
                        "first": 26,
                        "last": 26,
                        "children": [],
                        "type": "normal",
                        "id": "24154"
                    },
                    {
                        "index": {},
                        "first": 27,
                        "last": 27,
                        "children": [],
                        "type": "normal",
                        "id": "24155"
                    },
                    {
                        "index": {},
                        "first": 28,
                        "last": 28,
                        "children": [],
                        "type": "normal",
                        "id": "24156"
                    },
                    {
                        "index": {},
                        "first": 29,
                        "last": 29,
                        "children": [],
                        "type": "normal",
                        "id": "24157"
                    },
                    {
                        "index": {},
                        "first": 30,
                        "last": 30,
                        "children": [],
                        "type": "normal",
                        "id": "24158"
                    },
                    {
                        "index": {},
                        "first": 31,
                        "last": 31,
                        "children": [],
                        "type": "normal",
                        "id": "24159"
                    },
                    {
                        "index": {},
                        "first": 32,
                        "last": 32,
                        "children": [],
                        "type": "normal",
                        "id": "24160"
                    },
                    {
                        "index": {},
                        "first": 33,
                        "last": 33,
                        "children": [],
                        "type": "normal",
                        "id": "24161"
                    },
                    {
                        "index": {},
                        "first": 34,
                        "last": 34,
                        "children": [],
                        "type": "normal",
                        "id": "24162"
                    },
                    {
                        "index": {},
                        "first": 35,
                        "last": 35,
                        "children": [],
                        "type": "normal",
                        "id": "24163"
                    },
                    {
                        "index": {},
                        "first": 36,
                        "last": 36,
                        "children": [],
                        "type": "normal",
                        "id": "24164"
                    },
                    {
                        "index": {},
                        "first": 37,
                        "last": 37,
                        "children": [],
                        "type": "normal",
                        "id": "24165"
                    },
                    {
                        "index": {},
                        "first": 38,
                        "last": 38,
                        "children": [],
                        "type": "normal",
                        "id": "24166"
                    },
                    {
                        "index": {},
                        "first": 39,
                        "last": 39,
                        "children": [],
                        "type": "normal",
                        "id": "24167"
                    },
                    {
                        "index": {},
                        "first": 40,
                        "last": 40,
                        "children": [],
                        "type": "normal",
                        "id": "24168"
                    },
                    {
                        "index": {},
                        "first": 41,
                        "last": 41,
                        "children": [],
                        "type": "normal",
                        "id": "24169"
                    },
                    {
                        "index": {},
                        "first": 42,
                        "last": 42,
                        "children": [],
                        "type": "normal",
                        "id": "24170"
                    },
                    {
                        "index": {},
                        "first": 43,
                        "last": 43,
                        "children": [],
                        "type": "normal",
                        "id": "24171"
                    },
                    {
                        "index": {},
                        "first": 44,
                        "last": 44,
                        "children": [],
                        "type": "normal",
                        "id": "24172"
                    },
                    {
                        "index": {},
                        "first": 45,
                        "last": 45,
                        "children": [],
                        "type": "normal",
                        "id": "24173"
                    },
                    {
                        "index": {},
                        "first": 46,
                        "last": 46,
                        "children": [],
                        "type": "normal",
                        "id": "24174"
                    }
                ],
                "type": "root",
                "id": null
            },
            "lookups": [
                {
                    "24128": "Aug 2010",
                    "24129": "Sep 2010",
                    "24130": "Oct 2010",
                    "24131": "Nov 2010",
                    "24132": "Dec 2010",
                    "24133": "Jan 2011",
                    "24134": "Feb 2011",
                    "24135": "Mar 2011",
                    "24136": "Apr 2011",
                    "24137": "May 2011",
                    "24138": "Jun 2011",
                    "24139": "Jul 2011",
                    "24140": "Aug 2011",
                    "24141": "Sep 2011",
                    "24142": "Oct 2011",
                    "24143": "Nov 2011",
                    "24144": "Dec 2011",
                    "24145": "Jan 2012",
                    "24146": "Feb 2012",
                    "24147": "Mar 2012",
                    "24148": "Apr 2012",
                    "24149": "May 2012",
                    "24150": "Jun 2012",
                    "24151": "Jul 2012",
                    "24152": "Aug 2012",
                    "24153": "Sep 2012",
                    "24154": "Oct 2012",
                    "24155": "Nov 2012",
                    "24156": "Dec 2012",
                    "24157": "Jan 2013",
                    "24158": "Feb 2013",
                    "24159": "Mar 2013",
                    "24160": "Apr 2013",
                    "24161": "May 2013",
                    "24162": "Jun 2013",
                    "24163": "Jul 2013",
                    "24164": "Aug 2013",
                    "24165": "Sep 2013",
                    "24166": "Oct 2013",
                    "24167": "Nov 2013",
                    "24168": "Dec 2013",
                    "24169": "Jan 2014",
                    "24170": "Feb 2014",
                    "24171": "Mar 2014",
                    "24172": "Apr 2014",
                    "24173": "May 2014",
                    "24174": "Jun 2014"
                }
            ]
        },
        "offset": {
            "columns": 0,
            "rows": 0
        },
        "size": {
            "columns": 1,
            "rows": 47
        }
    }
}
JS

describe GooderData::Project::Report::Series do
  describe ".parse" do
    subject(:parse) { GooderData::Project::Report::Series.parse(JSON.parse(json)) }

    context "when there are only one series" do
      let(:json) { one_serie_json }

      it "should return one instance of Series" do
        expect(parse.size).to eq 1
      end

      describe "#data" do
        subject(:data) { parse.first.data }

        context "when the given x value is present in the series x axis" do
          [
            ['Jan 2014', '7108'],
            ['Feb 2014', '6620'],
            ['Mar 2014', '7812'],
            ['Apr 2014', '5026'],
            ['May 2014', '9723'],
            ['Jun 2014', '6595']
          ].each do |x, y|
            it "should return the y value of that point" do
              expect(data[x]).to eq y
            end
          end

        end
      end
    end

  end
end
