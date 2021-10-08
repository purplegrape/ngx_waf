use Test::Nginx::Socket 'no_plan';

run_tests();


__DATA__

=== TEST: URI

--- config
waf on;
waf_mode GET URL;
waf_rule_path /usr/local/nginx/conf/waf/rules/;
waf_cc_deny off rate=100r/m;
waf_cache off capacity=50;

--- pipelined_requests eval
[
    "GET /",
    "GET /test0"
]

--- error_code eval
[
    200,
    404
]

=== TEST: Black URI

--- config
waf on;
waf_mode FULL;
waf_rule_path /usr/local/nginx/conf/waf/rules/;
waf_cc_deny off rate=100r/m;
waf_cache on capacity=50;

--- pipelined_requests eval
[
    "GET /www.bak",
    "GET /static/index.php"
]

--- error_code eval
[
    403,
    403
]