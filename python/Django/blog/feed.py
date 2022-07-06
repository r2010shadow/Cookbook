from django.contrib.syndication.views import Feed
from .models import Entry


class LatestEntriesFeed(Feed):
    title = 'Wallace`s Blog'
    link = '/siteblogs/'
    description = 'Wallace`s newest blog.'

    def item(self):
        return Entry.objects.order_by('-created_time')[:5]

    def item_title(self, item):
        return item.title

    def item_description(self,item):
        return item.abstract