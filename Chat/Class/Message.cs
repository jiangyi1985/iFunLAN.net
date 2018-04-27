namespace Chat.Class
{
    public class Message
    {
        public decimal? ID { get; set; }

        public System.DateTime Time { get; set; }

        public User Sender { get; set; }

        public string Content { get; set; }

        public bool IsPic { get; set; }

        public string To { get; set; }
        public string From { get; set; }
    }
}
