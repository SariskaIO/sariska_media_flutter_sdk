package io.sariska.sariska_media_flutter_sdk;

import io.sariska.sdk.Conference;

public class ConferenceManager extends Conference {

    private Conference conference;

    public void createConference(){
        conference = new Conference();
    }

    @Override
    public void join(){
        conference.join();
    }


}
