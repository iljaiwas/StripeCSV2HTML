If you are using [Stripe](https://stripe.com) for payment processing, they'll give you an CSV file at the end of each payment period listing. That's not good enough for most accountants. Here is a small tool-chain for OS X developers, that will produce a somewhat nice looking HTML summary of your transactions. There a are a few German strings sprinkled in here and there, but you should get the idea. Also, the scripts assume that your Stripe account is set up to be paid in Euros.

#Usage:
./StripeCSV2HTML.sh <path_to_stripe_transfer_file.csv>

#Requirements:
[objc-run](https://github.com/iljaiwas/objc-run) has to be installed, which in in turn requires Xcode developer tools to be installed.