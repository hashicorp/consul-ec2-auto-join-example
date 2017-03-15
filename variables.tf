variable "aws_region" {
  description = "AWS region to create the environment"
}

variable "aws_access_key" {
  description = "AWS access key for account"
}

variable "aws_secret_key" {
  description = "AWS secret for account"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "namespace" {
  description = <<EOH
The namespace to create the virtual training lab. This should describe the
training and must be unique to all current trainings. IAM users, workstations,
and resources will be scoped under this namespace.

It is best if you add this to your .tfvars file so you do not need to type
it manually with each run
EOH
}

variable "servers" {
  description = "The number of consul servers."
}

variable "clients" {
  description = "The number of consul client instances"
}

variable "consul_version" {
  description = "The version of Consul to install (server and client)."
  default     = "0.7.5"
}

variable "vpc_cidr_block" {
  description = "The top-level CIDR block for the VPC."
  default     = "10.1.0.0/16"
}

variable "cidr_blocks" {
  description = "The CIDR blocks to create the workstations in."
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "consul_join_tag_key" {
  description = "The key of the tag to auto-jon on EC2."
  default     = "consul_join"
}

variable "consul_join_tag_value" {
  description = "The value of the tag to auto-join on EC2."
  default     = "training"
}

variable "public_key_path" {
  description = "The absolute path on disk to the SSH public key."
  default     = "~/.ssh/id_rsa.pub"
}

variable "animals" {
  default = [
    "anaconda",
    "ant",
    "ape",
    "badger",
    "bass",
    "bat",
    "bear",
    "bee",
    "beetle",
    "bird",
    "bison",
    "buffalo",
    "bulldog",
    "butterfly",
    "camel",
    "cat",
    "catfish",
    "cheetah",
    "chicken",
    "chipmunk",
    "cobra",
    "cod",
    "coyote",
    "crab",
    "cricket",
    "crow",
    "deer",
    "dinosaur",
    "dog",
    "dolphin",
    "donkey",
    "dove",
    "dragonfly",
    "duck",
    "eagle",
    "elephant",
    "elk",
    "falcon",
    "fish",
    "flamingo",
    "fly",
    "fowl",
    "fox",
    "frog",
    "goat",
    "goldfish",
    "gopher",
    "gorilla",
    "grasshopper",
    "greyhound",
    "haddock",
    "halibut",
    "hamster",
    "hawk",
    "hedgehog",
    "heron",
    "herring",
    "hornet",
    "horse",
    "hound",
    "human",
    "husky",
    "jaguar",
    "jellyfish",
    "kangaroo",
    "koala",
    "ladybug",
    "leopard",
    "lion",
    "lizard",
    "llama",
    "lobster",
    "lynx",
    "mackerel",
    "mammal",
    "marlin",
    "mockingbird",
    "mole",
    "monkey",
    "moose",
    "mosquito",
    "moth",
    "mouse",
    "mule",
    "mussel",
    "octopus",
    "orca",
    "ostrich",
    "otter",
    "owl",
    "ox",
    "oyster",
    "panda",
    "panther",
    "parrot",
    "peacock",
    "peafowl",
    "pelican",
    "penguin",
    "pig",
    "pigeon",
    "pike",
    "pony",
    "poodle",
    "porcupine",
    "possum",
    "prawn",
    "primate",
    "puffin",
    "puma",
    "python",
    "rabbit",
    "raccoon",
    "rat",
    "raven",
    "rooster",
    "salamander",
    "salmon",
    "scallop",
    "scorpion",
    "seahorse",
    "shark",
    "sheep",
    "shrimp",
    "silkworm",
    "skunk",
    "sloth",
    "slug",
    "snail",
    "snake",
    "sparrow",
    "spider",
    "squid",
    "squirrel",
    "starfish",
    "stingray",
    "stork",
    "swallow",
    "swan",
    "swordfish",
    "tapeworm",
    "termite",
    "tern",
    "terrier",
    "tiger",
    "toad",
    "toucan",
    "trout",
    "tuna",
    "turkey",
    "turtle",
    "viper",
    "vulture",
    "wallaby",
    "walrus",
    "wasp",
    "weasel",
    "whale",
    "wildcat",
    "wolf",
    "wombat",
    "worm",
    "yak",
    "zebra",
  ]
}
